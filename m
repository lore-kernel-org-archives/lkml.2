Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2LRWnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:43:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48230 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2LRWne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:43:34 -0500
Date: Tue, 18 Dec 2012 23:43:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
Message-ID: <20121218224331.GB4937@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 11:15:32PM -0800, Yinghai Lu wrote:
> Now we have limit kdump reseved under 896M, because kexec has the limitation.
> and also bzImage need to stay under 4g.
> 
> To make kexec/kdump could use range above 4g, we need to make bzImage and
> ramdisk could be loaded above 4g.
> During booting bzImage will be unpacked on same postion and stay high.
> 
> The patches add fields in setup_header and boot_params to
> 1. get info about ramdisk position info above 4g from bootloader/kexec
> 2. get info about cmd_line_ptr info above 4g from bootloader/kexec
> 3. set xloadflags bit0 in header for bzImage and bootloader/kexec load
>    could check that to decide if it could to put bzImage high.
> 4. use sentinel to make sure ext_* fields in boot_params could be used.
> 
> This patches is tested with kexec tools with local changes and they are sent
> to kexec list later.
> 
> could be found at:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot
> 
> and it is on top of linus's tree 2012-12-17
> plus tip:x86/mm, tip:x86/urgent, tip:x86/mm2

Ok, I have a question. So I started reviewing those and then a couple of
days later you've sent a new patchset and have ignored all the review
comments I made. They weren't a lot but still.

So now that I see this new one, I'm not really inclined to look at it
anymore because if you ignore that feedback again, then I'm clearly
wasting my time. And I don't want to waste my time. I could be out
fishing for all I know, instead of sitting in front of the crate here.

So please, would you be so nice and tell me which is it:

* you're not at all interested in feedback

* you're not interested in *my* feedback, specifically

* you don't care about properly written commit messages, as long as they work

* writing proper commit messages is for pussies

* ... anything else I can't think of.


So I'd appreciate it if you stated which is it. I mean, it makes a very
little sense, if any, to waste each-other's time and therefore, stating
it out in the open is definitely and constructively more helpful. This
way we all know where we're headed.

Thanks a lot for your time.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
