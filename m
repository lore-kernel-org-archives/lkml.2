Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112Ab2IFAsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:48:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:8624 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab2IFAsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,377,1344236400"; 
   d="scan'208";a="141981820"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
CC: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alexander.deucher@amd.com" <alexander.deucher@amd.com>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "Shi, Yang A" <yang.a.shi@intel.com>
Subject: RE: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Topic: [Patch 0/1]drm_irq: Introducing the irq_thread support
Thread-Index: AQHNi2ovGw34DfcXvEyjDrzHnr2E5pd8e0cg
Date: Thu, 6 Sep 2012 00:48:02 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A177FC1@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A177306@SHSMSX101.ccr.corp.intel.com>
 <20120905132724.GC5357@phenom.ffwll.local>
In-Reply-To: <20120905132724.GC5357@phenom.ffwll.local>
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

> For a kms drm driver (and tbh, doing a non-kms driver today is not a great idea),
> there's no reason to use the drm_irq_install/_unistall helpers.
> 
Can not understand well, I found many GPU drivers are using drm_irq helpers' function, including ours:)

