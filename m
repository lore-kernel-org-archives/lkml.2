Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab1GKBXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 21:23:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49351 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab1GKBXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 21:23:05 -0400
Date: Mon, 11 Jul 2011 09:22:42 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110711012242.GC2135@localhost.localdomain>
References: <20110707053036.173186930@google.com>
 <1310037225.3282.538.camel@twins>
MIME-Version: 1.0
In-Reply-To: <1310037225.3282.538.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-11 09:22:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-11 09:22:21,
	Serialize complete at 2011-07-11 09:22:21
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 01:13:45PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-06 at 22:30 -0700, Paul Turner wrote:
> > base                                        7,526,317,497           8,666,579,347            1,771,078,445
> > +patch, cgroup not enabled                  7,610,354,447 (1.12%)   8,569,448,982 (-1.12%)   1,751,675,193 (-0.11%) 
> 
> "cgroup not enabled" means compiled in but not used at runtime, right?

Yes.

-- 
Thanks,
Hu Tao
