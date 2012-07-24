Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933701Ab2GXSNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:13:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36008 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923Ab2GXSEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+qZnSRNAAN6erat3Umuk6U9VYuc5SiQYK6PL8bHYAOcQ+SnAw@mail.gmail.com>
References: <CA+qZnSRNAAN6erat3Umuk6U9VYuc5SiQYK6PL8bHYAOcQ+SnAw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Jul 2012 11:03:50 -0700
X-Google-Sender-Auth: gr4TPTgbBVFfj99pIysATzvLsoA
Message-ID: <CA+55aFztHJos8Lo0+0Ew1kAV90g91dt28JsUOzpiJ1eqWGA1jQ@mail.gmail.com>
Subject: Re: Suse 11 SP1 kernel panic on HP hardware
To: tingwei liu <tingw.liu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 4:39 PM, tingwei liu <tingw.liu@gmail.com> wrote:
> Suse 11 SP1 kernel panic。
>
> I can't debug it without debuginfo. Who can give me a link of sels
> 2.6.32.12-0.7.default.debug or give some advise.
>
> kernel: [3077010.856280] BUG: unable to handle kernel NULL pointer
> dereference at 0000000000000008
> kernel: [3077010.856291] IP: [<ffffffff81046958>] find_busiest_group+0x348/0x8b0

We've had bugs in there in the past, but you really need to contact
the suse people. That's a very old kernel.

                   Linus
