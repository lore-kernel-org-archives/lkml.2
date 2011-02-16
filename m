Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1BPUTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:19:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:4324 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1BPUTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:19:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,481,1291622400"; 
   d="scan'208";a="888139834"
Date: Wed, 16 Feb 2011 12:18:59 -0800
From: Jesse Barnes <jesse.barnes@intel.com>
To: "jgq516@gmail.com" <jgq516@gmail.com>
Cc: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] drm: fix wrong usages of drm_device in DRM
 Developer's Guide
Message-ID: <20110216121859.31ab0e57@jbarnes-desktop>
In-Reply-To: <1297677503-11175-1-git-send-email-jgq516@gmail.com>
References: <1297677503-11175-1-git-send-email-jgq516@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011 01:58:23 -0800
"jgq516@gmail.com" <jgq516@gmail.com> wrote:

> From: Xiao Jiang <jgq516@gmail.com>
> 
> A few wrong usages of drm_device, which should be drm_driver.
> 

Ah thanks, yeah it's mixed up.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
