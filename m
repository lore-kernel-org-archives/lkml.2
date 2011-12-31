Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046Ab1LaGiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 01:38:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64831 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1LaGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 01:38:04 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325222632-28382-1-git-send-email-olof@lixom.net>
References: <1325218186-6443-1-git-send-email-olof@lixom.net>
	<1325222632-28382-1-git-send-email-olof@lixom.net>
Date: Fri, 30 Dec 2011 22:38:02 -0800
Message-ID: <CAOesGMhJQn8mpAC-JoSH-1FeB5hSDhonJnTqvUsHj+_5AT7aUw@mail.gmail.com>
Subject: Re: [PATCH] x86: efi: Allow basic EFI use on mixed 32/64 firmware/kernel
From: Olof Johansson <olof@lixom.net>
To: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 9:23 PM, Olof Johansson <olof@lixom.net> wrote:

> I have tested this on 64-bit EFI with 64- and 32-bit kernels. I
> unfortunately don't have ready access to a 64-bit capable system that
> runs a 32-bit EFI to test it that way around. If someone else has such
> a system, I would appreciate a Tested-by.

I didn't do reviewers any favors by submitting the patch like this,
it's quite hard to review the way that git format-patch exports it.

I have also been able to test this on a MacBook2,1 (32-bit EFI) with
64-bit kernel. Only combination left untested so far is a 64-bit EFI
that locates data high with a 32-bit kernel to verify those error
paths.

So, I have a short series of patches that does cleanups and
refactorings first, then adds the 32/64-mixed support on top of it. I
want to test it a bit more before I repost, but I wanted to give the
heads up in case someone starts to spend time reviewing this -- might
as well hold off until the series is posted.


-Olof
