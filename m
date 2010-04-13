Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab0DMGtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:49:00 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41600 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0DMGs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:48:59 -0400
Date: Tue, 13 Apr 2010 12:18:55 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memcg: update documentation v5
Message-ID: <20100413064855.GH3994@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20100408145800.ca90ad81.kamezawa.hiroyu@jp.fujitsu.com>
 <20100409134553.58096f80.kamezawa.hiroyu@jp.fujitsu.com>
 <20100409100430.7409c7c4.randy.dunlap@oracle.com>
 <20100413134553.7e2c4d3d.kamezawa.hiroyu@jp.fujitsu.com>
 <20100413060405.GF3994@balbir.in.ibm.com>
 <20100413152048.55408738.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100413152048.55408738.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-04-13 15:20:48]:

[snip]

The alignment does not show up in the patches, hence the comments

> > Do we need the <> around memory.usage_in_bytes
> > 
> 
> Hmm ? I'm not sure. 
> 
> Could you explain why you think removing <> is better ?
>

Because it is an actual name as compared to using <> for to be
replaced with the right thing. 

-- 
	Three Cheers,
	Balbir
