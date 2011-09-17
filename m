Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1IQN0W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 09:26:22 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:35755 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1IQN0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 09:26:20 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 06/20] Staging: hv: util: Properly handle util services
 in the util driver
Thread-Topic: [PATCH 06/20] Staging: hv: util: Properly handle util services
 in the util driver
Thread-Index: AQHMcjvtYv4obMHbH0CnnF+Bjxcf2ZVQxquAgADNDGA=
Date: Sat, 17 Sep 2011 13:26:19 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081E774A@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-6-git-send-email-kys@microsoft.com>
 <20110916180311.GB25531@kroah.com>
In-Reply-To: <20110916180311.GB25531@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Friday, September 16, 2011 2:03 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 06/20] Staging: hv: util: Properly handle util services in the
> util driver
> 
> On Tue, Sep 13, 2011 at 10:59:42AM -0700, K. Y. Srinivasan wrote:
> >  static int __init init_hyperv_utils(void)
> >  {
> > -	int ret;
> >  	pr_info("Registering HyperV Utility Driver\n");
> 
> All of these "registering" and "unregistering" messages should be
> removed, they do nothing but clutter up the logs and are pointless.  You
> can find this information out any time you want by looking in sysfs
> instead of trying to parse random strings out of the kernel log.

I was just trying to preserve the messages that were being put out
In the existing code. I will get rid of these messages and send you updated
patches.

Regards,

K. Y
