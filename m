Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab1DARb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 13:31:58 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38724 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973Ab1DARb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 13:31:57 -0400
Date: Fri, 1 Apr 2011 23:01:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
Message-ID: <20110401173145.GT2879@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110330052819.8212.1359.stgit@localhost6.localdomain6>
 <20110330163607.0984b831.akpm@linux-foundation.org>
 <20110331052703.GJ2879@balbir.in.ibm.com>
 <20110330223231.e1f149eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110330223231.e1f149eb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2011-03-30 22:32:31]:

> On Thu, 31 Mar 2011 10:57:03 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > * Andrew Morton <akpm@linux-foundation.org> [2011-03-30 16:36:07]:
> > 
> > > On Wed, 30 Mar 2011 11:00:26 +0530
> > > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 
> > > > Data from the previous patchsets can be found at
> > > > https://lkml.org/lkml/2010/11/30/79
> > > 
> > > It would be nice if the data for the current patchset was present in
> > > the current patchset's changelog!
> > >
> > 
> > Sure, since there were no major changes, I put in a URL. The main
> > change was the documentation update. 
> 
> Well some poor schmuck has to copy and paste the data into the
> changelog so it's still there in five years time.  It's better to carry
> this info around in the patch's own metedata, and to maintain
> and update it.
>

Agreed, will do. 

-- 
	Three Cheers,
	Balbir
