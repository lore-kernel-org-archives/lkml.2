Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1GDL5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 07:57:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:49039 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1GDL5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 07:57:45 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Mon, 4 Jul 2011 13:57:43 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107042051.HEB57830.OJFtMLFSOHFVQO@I-love.SAKURA.ne.jp>
In-Reply-To: <201107042051.HEB57830.OJFtMLFSOHFVQO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041357.43481.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 04 Juli 2011, 13:51:55 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > Running a x86_64 kernel without ia32 emulation and a x86 user land
> > triggers this issue.
> 
> Executing /sbin/modprobe for x86_32 on an x86_64 kernel without x86_32
> support?

Yep.

> Anyway, request_module() calls __request_module() but
> __request_module() stops at MAX_KMOD_CONCURRENT levels of nesting.
> So, I think "infinite loop" cannot happen.

Booting a x86_64 UML kernel with x86_32 user land triggers this issue.
I always wondered why the UML kernel hangs an consumes 100% CPU.

Thanks,
//richard
