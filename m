Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0LOJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:23:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:15939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0LOJX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:23:28 -0500
Message-Id: <b9dded$hcr3k7@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,347,1288594800"; 
   d="scan'208";a="583896711"
Date: Wed, 15 Dec 2010 09:23:23 +0000
To: Hui Zhu <teawater@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] i915 boot got black screen with 2.6.37-rc5+
Cc: keithp@keithp.com, ak@linux.intel.com, gregkh@suse.de, stable@kernel.org,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com>
References: <AANLkTimOOmFqxU=r+-RphdfPJ54Qr+6LHU60Grzpnerr@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which chipset and what connectors? Judging by the offending commits, my
guess is an Arrandale with eDP, in which case
https://bugs.freedesktop.org/show_bug.cgi?id=31988 will be of interest.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
