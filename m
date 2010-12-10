Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab0LJBH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 20:07:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:11873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540Ab0LJBH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 20:07:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,322,1288594800"; 
   d="scan'208";a="685694570"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "dmitry.kasatkin@nokia.com" <dmitry.kasatkin@nokia.com>
Date: Thu, 9 Dec 2010 18:07:55 -0700
Subject: RE: [PATCH 01/11] Staging: sep: remove virtual address being passed
 to user space application
Thread-Topic: [PATCH 01/11] Staging: sep: remove virtual address being
 passed to user space application
Thread-Index: AcuYAuZUiytcO1wFTJePOw9348n2gQAA7yjQ
Message-ID: <8A0E4C92AE2D6D40AF99653191DA3231614627B823@rrsmsx501.amr.corp.intel.com>
References: <1291915803-18316-1-git-send-email-mark.a.allyn@intel.com>
 <20101210003717.GA28530@kroah.com>
In-Reply-To: <20101210003717.GA28530@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just changed it; another copy of that patch is being sent out now

-----Original Message-----
From: Greg KH [mailto:greg@kroah.com] 
Sent: Thursday, December 09, 2010 4:37 PM
To: Allyn, Mark A
Cc: linux-kernel@vger.kernel.org; alan@linux.intel.com; dmitry.kasatkin@nokia.com
Subject: Re: [PATCH 01/11] Staging: sep: remove virtual address being passed to user space application

On Thu, Dec 09, 2010 at 09:30:03AM -0800, Mark Allyn wrote:
> @@ -3064,7 +3051,7 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		break;
>  	case SEP_IOCGETSTATICPOOLADDR:
>  		/* Get the physical and virtual addresses of the static pool */
> -		error = sep_get_static_pool_addr_handler(sep, arg);
> +		error = sep_get_static_pool_addr_handler(sep);

This comment should be changed as well, right?

thanks,

greg k-h
