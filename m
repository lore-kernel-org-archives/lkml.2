Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab0DHUCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:02:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40923 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab0DHUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:02:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Bug #15668] start_kernel(): bug: interrupts were enabled early
Date: Thu, 8 Apr 2010 22:06:00 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>, Rabin Vincent <rabin@rab.in>,
       Yinghai Lu <yinghai@kernel.org>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.4LH.YtPvLB@chimera> <4BBD07F9.5060106@zytor.com>
In-Reply-To: <4BBD07F9.5060106@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082206.00243.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, H. Peter Anvin wrote:
> On 04/07/2010 02:13 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15668
> > Subject		: start_kernel(): bug: interrupts were enabled early
> > Submitter	: Rabin Vincent <rabin@rab.in>
> > Date		: 2010-03-25 19:53 (14 days old)
> > First-Bad-Commit: http://git.kernel.org/git/linus/773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9
>                                          ^^^^
> 
> FWIW, this /git is redundant.

Ah, thanks for the hint. :-)

Rafael
