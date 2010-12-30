Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064Ab0L3WTE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:19:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:58204 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab0L3WTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:19:03 -0500
Message-Id: <0d30dc$kk13q5@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,251,1291622400"; 
   d="scan'208";a="692096837"
Date: Thu, 30 Dec 2010 22:18:55 +0000
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] i915 fixes
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101230140103.1189c545@jbarnes-desktop>
References: <0d30dc$kjvpke@orsmga001.jf.intel.com> <20101230140103.1189c545@jbarnes-desktop>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Dec 2010 14:01:03 -0800, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> Did you want to disable SSC entirely on gen5+ just so we can get all
> the known machines working?  It's possible it could add some wifi or
> sound interference, but that's better than not having a display (most
> of the time).

My first step was to simply restore the behaviour to 2.3.36 and then look
for an alternate patch. I'd like to give any such patch at least the
chance for smoketesting by QA (and the machines here) before asking
Linus to pull ;-)

There is one interesting difference between the BIOS and KMS clock setting
for the Lenovo U160; the BIOS is able to set n=1, whereas we can't find a
suitable clock with just a single wire. Maybe we can fix the U160 and save
0.1W as well!

As far as I am aware, only the LVDS panel on the U160 is broken. Does
anyone else have a panel that sprang to life (ignoring the recent bug)
by disabling SSC?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
