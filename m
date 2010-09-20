Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0ITSII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:08:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:23767 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab0ITSIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:08:06 -0400
Message-Id: <8u3s94$giian9@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,394,1280732400"; 
   d="scan'208";a="556346089"
Date: Mon, 20 Sep 2010 19:08:02 +0100
To: balbi@ti.com, airlied@linux.ie
Subject: Re: i915 regression (??)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20100920062841.GA32493@legolas.emea.dhcp.ti.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <20100920062841.GA32493@legolas.emea.dhcp.ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 09:28:42 +0300, Felipe Balbi <balbi@ti.com> wrote:
> I believe 2.6.36-rc4 has a regresion ? With .32 (debian sid package) I
> had everything working fine, but with .36-rc4 no output comes on LVDS,
> only on my HDMI external monitor. Here's the xrandr output:

You don't have LVDS, but eDP. We are working on getting the power-on
sequence correct for all systems but alas we still in the phase where we
fix it for some machines and cause others to fail.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
