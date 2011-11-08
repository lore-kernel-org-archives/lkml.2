Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1KHTEJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:04:09 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51140 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1KHTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <1320775737.2382.42.camel@deneb.redhat.com>
References: <1320179267.14825.107.camel@deneb.redhat.com> <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
 <1320529182.14081.78.camel@deneb.redhat.com> <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
 <1320775737.2382.42.camel@deneb.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Nov 2011 11:03:45 -0800
X-Google-Sender-Auth: 4Q4WKMTUZQmdRbsvpY5uHnaDNMU
Message-ID: <CA+55aFx_bjbpbY8wG11UqVmnK_-hNJBQTM_OhAAMjDyEyvbtUg@mail.gmail.com>
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "JACQUIOT-XID, Aurelien" <a-jacquiot@ti.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 8, 2011 at 10:08 AM, Mark Salter <msalter@redhat.com> wrote:
>
> Having a little time to think about this some more, I'm going to take
> another crack at it. Defining __pa/__va with PAGE_OFFSET as they are
> currently creates a physical space which doesn't match the hardware
> when PAGE_OFFSET is non-zero.
>
> For arches using device tree support, that means that the physical
> addresses in the device tree are either linux-specific or early boot
> code would have to go through the tree to fixup the "hardware physical"
> addresses so that they are "linux physical" addresses for the kernel.

Ok, that's actually a good argument - external interfaces defining
what "physical" means.

Fair enough. I'll consider myself convinced.

         Linus
