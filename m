Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab2LTGQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 01:16:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:35443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab2LTGQS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 01:16:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="260017799"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Zhang, Rui" <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hongbo.zhang@linaro.org" <hongbo.zhang@linaro.org>,
        "wni@nvidia.com" <wni@nvidia.com>
Subject: RE: [PATCH 0/8] Thermal Framework Enhancements
Thread-Topic: [PATCH 0/8] Thermal Framework Enhancements
Thread-Index: AQHN3QLYWsFdy6+maESoXsRsheh4gZgg0huAgABlL6A=
Date: Thu, 20 Dec 2012 06:16:07 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5924C60E@BGSMSX101.gar.corp.intel.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
 <20121220053757.GD28007@kroah.com>
In-Reply-To: <20121220053757.GD28007@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, December 20, 2012 11:08 AM
> To: R, Durgadoss
> Cc: Zhang, Rui; linux-pm@vger.kernel.org; linux-kernel@vger.kernel.org;
> hongbo.zhang@linaro.org; wni@nvidia.com
> Subject: Re: [PATCH 0/8] Thermal Framework Enhancements
> 
> On Tue, Dec 18, 2012 at 02:59:29PM +0530, Durgadoss R wrote:
> > This patch is a v1 based on the RFC submitted here:
> > https://patchwork.kernel.org/patch/1758921/
> >
> > This patch set is based on Rui's -thermal tree, and is
> > tested on a Core-i5 and an Atom netbook.
> >
> > This series contains 8 patches:
> > Patch 1/8: Creates new sensor level APIs
> > Patch 2/8: Creates new zone level APIs. The existing tzd structure is
> >            kept as such for clarity and compatibility purposes.
> > Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
> >            existing tcd structure need not be modified.
> > Patch 4/8: Adds a thermal_trip sysfs node, which exposes various trip
> >            points for all sensors present in a zone.
> > Patch 5/8: Adds a thermal_map sysfs node. It is a compact representation
> >            of the binding relationship between a sensor and a cdev,
> >            within a zone.
> > Patch 6/8: Creates Documentation for the new APIs. A new file is
> >            created for clarity. Final goal is to merge with the existing
> >            file or refactor the files, as whatever seems appropriate.
> 
> The documentation for sysfs files needs to be in Documentation/ABI,
> please add new entries there if you are creating new sysfs files.

This patch was meant to add Documentation in the standard .txt under
Documentation/thermal/.

So, will keep this patch, and also add one more patch to document these
ABI under Documentation/ABI/testing/.

Thanks,
Durga

> 
> thanks,
> 
> greg k-h
