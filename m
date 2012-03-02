Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab2CBD0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:26:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:51514 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab2CBD0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:26:08 -0500
MIME-Version: 1.0
In-Reply-To: <4F4F9520.9070309@teksavvy.com>
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
 <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com>
 <4F4F8BEE.3040806@teksavvy.com> <4F4F9520.9070309@teksavvy.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 1 Mar 2012 19:25:46 -0800
X-Google-Sender-Auth: h3_Y9gX0KuJZZixksfN2IEI5gPA
Message-ID: <CA+55aFx76KoXN1oC43PpSiSy9MdExWfQoPLUH3yZAM==ULMGwg@mail.gmail.com>
Subject: Re: [PATCH] i8k: fix ioctl handing (was Re: Linux 3.3-rc5)
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 7:26 AM, Mark Lord <kernel@teksavvy.com> wrote:
>
> I'm still not 100% happy with the arg/argp passing to i8ki_unlocked_ioctl() though.
> Shouldn't there be a compat_ptr() macro in there someplace?

Yes, I think you should have "compat_ptr(arg)" there.

Patch looks good. And perhaps i8k_get_bios_version() should be renamed
to "i8k_get_smm_bios_version()" to not cause this crazy confusion
again.

                    Linus
