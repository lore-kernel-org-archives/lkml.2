Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab1H3ROc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:14:32 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:42182 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1H3ROa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:14:30 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <error27@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 10/59] Staging: hv: util: Make hv_utils a vmbus device
 driver
Thread-Topic: [PATCH 10/59] Staging: hv: util: Make hv_utils a vmbus device
 driver
Thread-Index: AQHMY0j4AdDOyNz8yEOfGJ/AvbFSMpU2CKuA//+hJrA=
Date: Tue, 30 Aug 2011 17:14:29 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5342@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-10-git-send-email-kys@microsoft.com>
 <20110830155323.GT3705@shale.localdomain>
In-Reply-To: <20110830155323.GT3705@shale.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:error27@gmail.com]
> Sent: Tuesday, August 30, 2011 11:53 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang
> Subject: Re: [PATCH 10/59] Staging: hv: util: Make hv_utils a vmbus device driver
> 
> On Thu, Aug 25, 2011 at 09:48:36AM -0700, K. Y. Srinivasan wrote:
> > +	util_drv.driver.name = driver_name;
> > +
> > +	return vmbus_child_driver_register(&util_drv.driver);
> 
> We should free the allocations if vmbus_child_driver_register() fails.

Thanks Dan. I will take care of this.

Regards,

K. Y

