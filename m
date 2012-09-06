Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab2IFAyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:54:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:44677 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2IFAya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,377,1344236400"; 
   d="scan'208";a="141983072"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>, "Shi, Yang A" <yang.a.shi@intel.com>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>
Subject: RE: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Topic: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Index: AQHNi2ovGw34DfcXvEyjDrzHnr2E5pd7VNaAgAAFbACAASF8gA==
Date: Thu, 6 Sep 2012 00:54:05 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A177FD0@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
 <20120905132724.GC5357@phenom.ffwll.local>
 <E3ED5BF57CCD1C40876FA2D3385ED5D30FD781AC@SHSMSX102.ccr.corp.intel.com>
 <20120905153204.GD5357@phenom.ffwll.local>
In-Reply-To: <20120905153204.GD5357@phenom.ffwll.local>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, you cant use the pre_install/post_install hooks the drm_irq code provides,
> but yes, just do the request_irq in your driver code at the right time, with the
> right parameters. Much easier than adding code to a part of the drm core
> fraught with backwards-compat stuff no one really wants to touch ... All the
> additional stuff besides calling request_irq and the driver hooks that
> drm_irq_install does is really just to support old dri1 userspace.
> 
Please have a look for the patch, I just added the callback of irq thread handler, default is NULL without set,
So it should be no impact with others.

In case irq threadler func is NULL, it equals to request_irq, thanks.
