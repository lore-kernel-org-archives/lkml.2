Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab2JGGhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 02:37:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55408 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2JGGhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 02:37:14 -0400
Subject: Re: AW: [REGRESSION] Kernel 3.6 drops network packets instead of
 forwarding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <B3A09DD14C7DC341B8B4D309FE5DD1BE1513FAA4@G2W2525.americas.hpqcorp.net>
References: <B3A09DD14C7DC341B8B4D309FE5DD1BE1513FAA4@G2W2525.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Oct 2012 08:37:09 +0200
Message-ID: <1349591829.21172.2042.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-06 at 17:52 +0000, Chini, Georg (HP App Services) wrote:
> Hello,
> 
> > Looks like the bug fixed by : 
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=f4ef85bbda96324785097356336bc79cdd37db0a
> >
> > (David Miller will send it to stable team shortly)
> 
> Yes, you are right. Applied the patch and it fixes the problem.
> Thanks a lot for your help.

Thanks for testing !


