Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0IDJVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 05:21:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:21638 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab0IDJVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 05:21:13 -0400
Message-Id: <89k83a$9hv9li@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,317,1280732400"; 
   d="scan'208";a="320841394"
Date: Sat, 04 Sep 2010 10:21:07 +0100
To: Pekka Enberg <penberg@kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1283588234-2514-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  4 Sep 2010 11:17:14 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit causes
> wrong screen resolution on some i915 machines such as MacBook which is a
> regression from 2.6.35. The issue has been reported multiple times but no fix
> has emerged:

NAK. You can't simply hide one bug by introducing a much bigger one.

As you have an affected machine, find which wait_for_vblank() needs to be
replaced with a msleep(20|50).

-- 
Chris Wilson, Intel Open Source Technology Centre
