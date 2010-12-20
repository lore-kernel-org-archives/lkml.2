Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab0LTTwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 14:52:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:28504 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744Ab0LTTwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 14:52:11 -0500
Message-Id: <0d30dc$kh3cm9@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,203,1291622400"; 
   d="scan'208";a="689025737"
Date: Mon, 20 Dec 2010 19:52:07 +0000
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen entries not stolen memory"
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
In-Reply-To: <201012202047.08544.arnd@arndb.de>
References: <201012201912.19051.arnd@arndb.de> <849307$arcbdv@azsmga001.ch.intel.com> <201012202047.08544.arnd@arndb.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, which modules do you have loaded when using VESA? i.e. is the
i915.ko loaded, but in UMS mode (i915.modeset=0)?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
