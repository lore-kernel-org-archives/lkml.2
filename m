Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2ACUlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:41:40 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16992 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2ACUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:41:38 -0500
Date: Tue, 3 Jan 2012 15:39:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Konrad Rzeszutek Wilk <konrad@darnok.org>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>, "Brown, Len" <len.brown@intel.com>,
        "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 01/10] Add mcelog support from xen platform
Message-ID: <20120103203912.GG17472@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923359699@SHSMSX101.ccr.corp.intel.com>
 <20111223124208.GA25286@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111223124208.GA25286@andromeda.dapyr.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F0367D0.000A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 23, 2011 at 08:42:08AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Dec 23, 2011 at 10:23:03AM +0000, Liu, Jinsong wrote:
> > >From 0e8de1ce0f13aa34aa6013e6a387ae5be78031ca Mon Sep 17 00:00:00 2001
> > From: Liu Jinsong <jinsong.liu@intel.com>
> > Date: Tue, 6 Dec 2011 18:08:12 +0800
> > Subject: [PATCH 01/10] Add mcelog support from xen platform
> 
> .. for xen platform.
> > 
> > This patch backport from Jeremy's pvops commit a5ed1f3dae179158e385e9371462dd65d5e125c5,
> > which in turn backport from previous xen DOM0(2.6.18) cs: 75e5bfa7fbdc
> 
> Ok. You should also include a link to the tree.

Actually on a second thought we don't need it. This patch (and all the others)
have never been posted upstream. So the back-history is not really that interesting
unless there has been a lot of churn (say the authorship changed or you had to
redo some serious surgery on it).
