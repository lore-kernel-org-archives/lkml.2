Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab0IHPUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:20:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:27252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0IHPUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:20:13 -0400
Message-Id: <8u3s8d$jgt7hk@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,335,1280732400"; 
   d="scan'208";a="655269428"
Date: Wed, 08 Sep 2010 16:19:55 +0100
To: Woody Suwalski <terraluna977@gmail.com>
Subject: Re: [regression] i915 incorrectly detects bogus LVDS connection instead of LVDS1
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
References: <AANLkTim2mrVRCKg-2couMTFV7krHQp0+2e_cbaiT_KYW@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTim2mrVRCKg-2couMTFV7krHQp0+2e_cbaiT_KYW@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 11:10:42 -0400, Woody Suwalski <terraluna977@gmail.com> wrote:
> LVDS connected 800x600+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
> LVDS-1 connected 800x600+0+0 (normal left inverted right x axis y

The -intel driver does not generate either of these names, it strictly
uses "%s%d" or "UNKNOWN" for the output name. Maybe an Xorg.log would
help identify the issue?

-- 
Chris Wilson, Intel Open Source Technology Centre
