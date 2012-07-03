Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2GCPHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:07:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56963 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2GCPHf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 3 Jul 2012 11:07:35 -0400
Message-Id: <4FF3270C020000780008D5A9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 03 Jul 2012 16:08:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Christoph Egger" <Christoph.Egger@amd.com>,
        "Tony Luck" <tony.luck@intel.com>
Cc: "IanCampbell" <Ian.Campbell@citrix.com>, "Ashok Raj" <ashok.raj@intel.com>,
        "Donald D Dugger" <donald.d.dugger@intel.com>,
        "Haitao Shan" <haitao.shan@intel.com>,
        "Jinsong Liu" <jinsong.liu@intel.com>,
        "Jun Nakajima" <jun.nakajima@intel.com>,
        "Susie Li" <susie.li@intel.com>, "Will Auld" <will.auld@intel.com>,
        "Xiantao Zhang" <xiantao.zhang@intel.com>,
        "Yunhong Jiang" <yunhong.jiang@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "KeirFraser" <keir@xen.org>
Subject: Re: [Xen-devel] [xen vMCE RFC V0.2] xen vMCE design
References: <DE8DF0795D48FD4CA783C40EC829233525D395@SHSMSX101.ccr.corp.intel.com>
 <4FEB236C020000780008C392@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263B9D@SHSMSX101.ccr.corp.intel.com>
 <4FEC3B4A020000780008C673@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335263D6C@SHSMSX101.ccr.corp.intel.com>
 <4FEC463E020000780008C6A7@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335264914@SHSMSX101.ccr.corp.intel.com>
 <4FEC7FB8020000780008C885@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC8292335265284@SHSMSX101.ccr.corp.intel.com>
 <4FED7C5F.1040908@amd.com>
 <DE8DF0795D48FD4CA783C40EC8292335282ED5@SHSMSX101.ccr.corp.intel.com>
 <4FF2B87C020000780008D3E0@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F1933C278@ORSMSX104.amr.corp.intel<3908561D78D1C84285E8C5FCA982C28F1933C278@ORSMSX104.amr.corp.intel.com>
 <4FF306C1.7000100@amd.com>
In-Reply-To: <4FF306C1.7000100@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.07.12 at 16:50, Christoph Egger <Christoph.Egger@amd.com> wrote:
> On 07/03/12 15:26, Luck, Tony wrote:
> 
>>> I'm not convinced of the need, and would prefer aiming at a
>>> shared implementation unless issues arise that make this
>>> impossible.
>> 
>> It does sound odd. Yes, Intel and AMD have differences around CMCI ... but 
> we are never
>> going to send a CMCI to a guest (there is no point, it can't do anything 
> useful with the
>> information, it may do something pointlessly stupid like stop using a guest 
> physical page).
>> The only reason I suggested making MCG_CAP pretend that CMCI was supported 
> was a
>> small optimization ... if a Linux guest sees that CMCI is supported, it will 
> not poll the machine
>> check banks looking for corrected errors.
> 
> 
> Are you talking about PV or HVM guest?
> 
> For HVM guests yes it makes sense to disable CMCI in MCG_CAP for both
> AMD and Intel.

"enable" you mean?

Jan

