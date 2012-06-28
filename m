Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab2F1Jy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:54:59 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53787 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2F1Jy6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 28 Jun 2012 05:54:58 -0400
Message-Id: <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 28 Jun 2012 10:55:42 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jinsong Liu" <jinsong.liu@intel.com>, "Will Auld" <will.auld@intel.com>
Cc: "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Tony Luck" <tony.luck@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Keir Fraser" <keir@xen.org>
Subject: RE: [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.06.12 at 11:40, "Liu, Jinsong" <jinsong.liu@intel.com> wrote:
> So I would like to push new vMCE as quickly as possible. What's the timeline 
> of vMCE developing that xen 4.2 could accept?

Weeks ago, really. See http://lists.xen.org/archives/html/xen-devel/2012-06/msg01619.html
and follow-ups - we'd really only consider getting the save/restore
interface into forward compatible shape as acceptable.

> I wonder if we could make major 
> components of vMCE done before xen 4.2 timeline, and leave the surrounding 
> features and the corner cases done later?

Unfortunately it's likely going to be even less. However, if split
that way, chances are things could go into e.g. 4.2.1.

Jan

