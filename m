Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1DFAOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 20:14:12 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:39049 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1DFAOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 20:14:09 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "KY Srinivasan" <kys@microsoft.com>
Subject: RE: [PATCH 07/07] Replaced printk with pr_info in hv_timesource
Thread-Topic: [PATCH 07/07] Replaced printk with pr_info in hv_timesource
Thread-Index: AQHL7le+k3abNSUAfUCxQMCErmh79ZRPNYCAgADMBhA=
Date: Wed, 6 Apr 2011 00:14:08 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5624984B5C0@TK5EX14MBXC120.redmond.corp.microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
 <1301432330-1705-8-git-send-email-hjanssen@microsoft.com>
 <20110405050045.GA4663@kroah.com>
In-Reply-To: <20110405050045.GA4663@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, April 04, 2011 10:01 PM
> To: Hank Janssen
> Cc: Haiyang Zhang; gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; KY Srinivasan
> Subject: Re: [PATCH 07/07] Replaced printk with pr_info in hv_timesource
> 
> >  #include <linux/version.h>
> >  #include <linux/clocksource.h>
> > @@ -91,7 +92,7 @@ static int __init init_hv_clocksource(void)
> >  	if (!dmi_check_system(hv_timesource_dmi_table))
> >  		return -ENODEV;
> >
> > -	printk(KERN_INFO "Registering HyperV clock source\n");
> > +	pr_info("Registering HyperV clock source\n");
> 
> Why is this line even needed at all?  Please remove it in future patches.
> 

Of course, since there have been so many changes I will wait a day or two 
To get stuff settled in staging and I will send the patch to remove it.

Hank.

