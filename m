Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3ACUq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 15:46:28 -0500
Received: from fieldses.org ([174.143.236.118]:52412 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab3ACUqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 15:46:25 -0500
Date: Thu, 3 Jan 2013 15:46:24 -0500
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: "Hangcheck timer elapsed... GPU hung" in 3.8.0-rc2
Message-ID: <20130103204624.GA2533@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got a crash after a few minutes of running 3.8.0-rc2, was able to
switch to a vt and look at dmesg:

  [  490.962545] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
  [  490.963019] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
  [  492.961446] [drm:i915_hangcheck_hung] *ERROR* Hangcheck timer elapsed... GPU hung
  [  492.965613] [drm:i915_reset] *ERROR* GPU hanging too fast, declaring wedged!
  [  492.965621] [drm:i915_reset] *ERROR* Failed to reset chip.  

Previously I was on 3.6.10-2.fc17.x86_64, which didn't have any such
problem.

dmesg, config, and i915_error_state available from:

	http://fieldses.org/~bfields/3.8-hang/

--b.
