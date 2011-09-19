Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab1ISWWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:22:18 -0400
Received: from home.keithp.com ([63.227.221.253]:41846 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1ISWWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:22:17 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: drm/i915: eDP cleanup patch series -- fixes SNB MacBook Air
Date: Mon, 19 Sep 2011 15:21:54 -0700
Message-Id: <1316470923-27832-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a sequence of eDP patches which are necessary to make the
driver work on the Sandybridge MacBook Air

The key trick was to make sure that the eDP power was applied before
trying to communicate with the device.

