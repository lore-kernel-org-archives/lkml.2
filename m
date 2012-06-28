Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab2F1J6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:58:37 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:6081 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab2F1J6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:58:36 -0400
X-IronPort-AV: E=Sophos;i="4.77,490,1336348800"; 
   d="scan'208";a="13264349"
Message-ID: <1340877513.10942.23.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: Jinsong Liu <jinsong.liu@intel.com>, Will Auld <will.auld@intel.com>,
        Tony Luck <tony.luck@intel.com>, "Keir (Xen.org)" <keir@xen.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>, Susie Li <susie.li@intel.com>,
        Haitao Shan <haitao.shan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Xiantao Zhang <xiantao.zhang@intel.com>
Date: Thu, 28 Jun 2012 10:58:33 +0100
In-Reply-To: <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
	 <4FEB236C020000780008C392@nat28.tlf.novell.com>
	 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
	 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
	 <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
	 <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-28 at 10:55 +0100, Jan Beulich wrote:
> >>> On 28.06.12 at 11:40, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> > So I would like to push new vMCE as quickly as possible. What's the timeline 
> > of vMCE developing that xen 4.2 could accept?
> 
> Weeks ago, really. See http://lists.xen.org/archives/html/xen-devel/2012-06/msg01619.html
> and follow-ups - we'd really only consider getting the save/restore
> interface into forward compatible shape as acceptable.

Yes it really is far to late to considering entire new features at this
stage.

Ian.

> 
> > I wonder if we could make major 
> > components of vMCE done before xen 4.2 timeline, and leave the surrounding 
> > features and the corner cases done later?
> 
> Unfortunately it's likely going to be even less. However, if split
> that way, chances are things could go into e.g. 4.2.1.
> 
> Jan
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel


