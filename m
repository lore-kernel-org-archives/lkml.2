Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab1FNHoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:44:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58618 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1FNHop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:44:45 -0400
Date: Tue, 14 Jun 2011 15:44:18 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.co>
Subject: Re: [patch 00/15] CFS Bandwidth Control V6
Message-ID: <20110614074418.GA3089@localhost.localdomain>
References: <20110503092846.022272244@google.com>
 <20110614065807.GA19111@localhost.localdomain>
 <4DF70DED.2030803@jp.fujitsu.com>
MIME-Version: 1.0
In-Reply-To: <4DF70DED.2030803@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-14 15:44:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-14 15:44:27,
	Serialize complete at 2011-06-14 15:44:27
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 04:29:49PM +0900, Hidetoshi Seto wrote:
> (2011/06/14 15:58), Hu Tao wrote:
> > Hi,
> > 
> > I've run several tests including hackbench, unixbench, massive-intr
> > and kernel building. CPU is Intel(R) Xeon(R) CPU X3430  @ 2.40GHz,
> > 4 cores, and 4G memory.
> > 
> > Most of the time the results differ few, but there are problems:
> > 
> > 1. unixbench: execl throughout has about 5% drop.
> > 2. unixbench: process creation has about 5% drop.
> > 3. massive-intr: when running 200 processes for 5mins, the number
> >    of loops each process runs differ more than before cfs-bandwidth-v6.
> > 
> > The results are attached.
> 
> I know the score of unixbench is not so stable that the problem might
> be noises ... but the result of massive-intr is interesting.
> Could you give a try to find which piece (xx/15) in the series cause
> the problems?

OK. I'll do it.

> 
> Thanks,
> H.Seto
