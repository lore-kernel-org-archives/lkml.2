Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab2JWTWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:22:40 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:64673 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab2JWTWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:22:39 -0400
Message-ID: <5086EE7C.2080608@tilera.com>
Date: Tue, 23 Oct 2012 15:22:36 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] tile: support GENERIC_KERNEL_THREAD and GENERIC_KERNEL_EXECVE
References: <20121016223508.GR2616@ZenIV.linux.org.uk> <201210192041.q9JKf7jD003998@farm-0010.internal.tilera.com> <20121019213548.GR2616@ZenIV.linux.org.uk> <5082A1F1.3080303@tilera.com> <20121020153401.GT2616@ZenIV.linux.org.uk> <20121020171643.GU2616@ZenIV.linux.org.uk> <5086D432.4070008@tilera.com> <20121023184122.GZ2616@ZenIV.linux.org.uk>
In-Reply-To: <20121023184122.GZ2616@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 2:41 PM, Al Viro wrote:
> On Tue, Oct 23, 2012 at 01:30:26PM -0400, Chris Metcalf wrote:
>> As you had suggested in an earlier email, I went ahead and eliminated the
>> special pt_regs handling for sigaltstack, rt_sigreturn, and clone.  (Also a
>> tilepro-specific syscall that was also using PTREG_SYSCALL.)  I'll send it
>> separately and you can include it in your tree if you like.
> OK by me...  Or just pull this arch-tile into a separate branch in your
> tree, add commit on top of it and I'll pull that.

Done in 

  git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git viro-signal-tile

Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

