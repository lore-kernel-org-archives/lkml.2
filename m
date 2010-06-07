Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab0FGQij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:38:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29748 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0FGQif (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 7 Jun 2010 12:38:35 -0400
Date: Mon, 7 Jun 2010 12:37:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.35-rc2
Message-ID: <20100607163746.GB13468@phenom.dumpdata.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C0D2082.015D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 09:15:36PM -0700, Linus Torvalds wrote:
> 
> So -rc2 is out there, and hopefully fixes way more problems than it 
> introduces.
> 
> I'm slightly unhappy with its size - admittedly it's not nearly as big as 
> rc2 was the last release cycle, but that was an unusually big -rc2. And I 
> really hoped for a calmer release cycle this time.
> 
> In fact, for once I'm going to enforce -rc3 being sane, because the 
> upcoming week is the last week of school for my kids. And when the kids 
> get out of school, I'm going be offline for a while. And as a result, I 
> _really_ don't want to pull anything even half-way scary in the next week 
> for -rc3.
> 
> So any pull requests had better be obvious fixes only, and this time I'm 
> not going to let things slide.

Hey Linus,

I am wondering what about git pull request that were sent before this
email but haven't been addressed yet? Specifically I am concerned
about: http://lkml.org/lkml/2010/6/2/301

It has been in the linux-next for months, and has gone through
reviews. Is there an outstanding issue that blocks the merge?
