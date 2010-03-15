Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab0COTc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:32:56 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41989 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0COTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:32:55 -0400
From: Surbhi Palande <surbhi.palande@canonical.com>
To: dri-devel@lists.sourceforge.net
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, airlied@linux.ie, yakui.zhao@intel.com,
       jbarnes@virtuousgeek.org, zhenyuw@linux.intel.com
Subject: [PATCH 0/2]  blacklist lid status: Sony VGN-BX196VP and Elite Co.
Date: Mon, 15 Mar 2010 21:32:41 +0200
Message-Id: <cover.1268680514.git.surbhi.palande@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <89k83ahv05c@azsmga001.ch.intel.com>
References: <89k83ahv05c@azsmga001.ch.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches are quirks that blacklist bios which report
incorrect lid status. These are bioses for machines with a 900 GM.
The first one is tested by Ubuntu users and the second one isn't.
Further testing will be appreciated.


Surbhi Palande (2):
  drm/i915: blacklist lid status: Sony VGN-BX196VP
  drm/i915: blacklist lid status: Elite Co. G335

 drivers/gpu/drm/i915/intel_lvds.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

