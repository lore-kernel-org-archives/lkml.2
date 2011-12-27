Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab1L0BHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 20:07:37 -0500
Received: from home.keithp.com ([63.227.221.253]:36361 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1L0BHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 20:07:32 -0500
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 0/2]: drm/i915: Disable RC6 and semaphores on SNB *again*
Date: Mon, 26 Dec 2011 17:02:09 -0800
Message-Id: <1324947731-22980-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This leaves them enabled on IVB, but disables them on SNB as we've
discovered (yet again) that there are hardware combinations that
simply cannot run with them.

 [PATCH 1/2] drm/i915: Disable semaphores by default on SNB
 [PATCH 2/2] drm/i915: Disable RC6 on Sandybridge by default

--
keith.packard@intel.com
