Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab2EIEHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 00:07:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44203 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903Ab2EIEHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 00:07:01 -0400
Message-ID: <1336536416.13700.8.camel@joe2Laptop>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 May 2012 21:06:56 -0700
In-Reply-To: <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
References: <1336004953.4240.9.camel@mop>
	 <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
	 <1336475689.1179.12.camel@mop>
	 <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 20:52 -0700, Linus Torvalds wrote:
> On Tue, May 8, 2012 at 4:14 AM, Kay Sievers <kay@vrfy.org> wrote:
> > Yeah, we need to make sure, we never merge the (always racy)
> > continuation printk() users with (non-racy) non-continuation users.
> > Therefore KERN_CONT is required to suppress the newline and to merge the
> > content with the earlier non-newline-terminated printk() line.
> 
> Please don't go adding ugly KERN_CONT when
> there really isn't any reason for it. Just fix the printk code you
> broke.

Thanks for making that clear.

