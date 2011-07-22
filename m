Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1GVRgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 13:36:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17627 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab1GVRgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 13:36:11 -0400
Date: Fri, 22 Jul 2011 13:35:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Randy Dunlap <rdunlap@xenotime.net>, dan.magenheimer@oracle.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com
Subject: Re: linux-next: Tree for July 22 (xen)
Message-ID: <20110722173548.GA7698@dumpdata.com>
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
 <20110722092245.589ec3d7.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722092245.589ec3d7.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E29B4FE.0075:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 09:22:45AM -0700, Randy Dunlap wrote:
> On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:
> 
> > Hi all,

Hey Randy,

This only shows up on xen but not xen-two?

> 
> build errors & warnings:  (full kernel config file is attached)
> 
> 
> drivers/xen/xen-selfballoon.c:95: warning: 'struct work_struct' declared inside parameter list
> drivers/xen/xen-selfballoon.c:95: warning: its scope is only this definition or declaration, which is probably not what you want
> drivers/xen/xen-selfballoon.c:96: warning: type defaults to 'int' in declaration of 'DECLARE_DELAYED_WORK'
> drivers/xen/xen-selfballoon.c:96: warning: parameter names (without types) in function declaration
> drivers/xen/xen-selfballoon.c:195: warning: 'struct work_struct' declared inside parameter list
> drivers/xen/xen-selfballoon.c:195: error: conflicting types for 'selfballoon_process'
> drivers/xen/xen-selfballoon.c:95: note: previous declaration of 'selfballoon_process' was here
> drivers/xen/xen-selfballoon.c: In function 'selfballoon_process':
> drivers/xen/xen-selfballoon.c:229: error: implicit declaration of function 'schedule_delayed_work'
> drivers/xen/xen-selfballoon.c:229: error: 'selfballoon_worker' undeclared (first use in this function)
> drivers/xen/xen-selfballoon.c:229: error: (Each undeclared identifier is reported only once
> drivers/xen/xen-selfballoon.c:229: error: for each function it appears in.)
> drivers/xen/xen-selfballoon.c:230: error: 'HZ' undeclared (first use in this function)
> drivers/xen/xen-selfballoon.c: In function 'store_selfballooning':
> drivers/xen/xen-selfballoon.c:266: error: 'selfballoon_worker' undeclared (first use in this function)
> drivers/xen/xen-selfballoon.c: In function 'xen_selfballoon_init':
> drivers/xen/xen-selfballoon.c:452: error: implicit declaration of function 'xen_domain'
> drivers/xen/xen-selfballoon.c:455: error: implicit declaration of function 'xen_initial_domain'
> drivers/xen/xen-selfballoon.c:478: error: 'selfballoon_worker' undeclared (first use in this function)
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


