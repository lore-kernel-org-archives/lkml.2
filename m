Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1ESP0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:26:23 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:4451 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751661Ab1ESP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:26:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAK411U1Ld/sX/2dsb2JhbAAMhE3bDZEbgSuDZ4EHBJ8i
X-IronPort-AV: E=Sophos;i="4.65,238,1304308800"; 
   d="scan'208";a="114244311"
Message-ID: <4DD5369B.1010601@teksavvy.com>
Date: Thu, 19 May 2011 11:26:19 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: Linux 2.6.39 -- *ERROR* Attempting to mmap a purgeable buffer
References: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
In-Reply-To: <BANLkTikB37AvEgh1MAFBbYvFaxsL6W11OQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just got weird stuff in the syslog this morning from rc7-git12:

[43190.824700] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.827426] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.827506] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.827568] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.828685] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.830498] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.830603] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.831055] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.832580] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer
[43190.832788] [drm:i915_gem_mmap_gtt] *ERROR* Attempting to mmap a purgeable buffer

[    0.000000] Linux version 2.6.39-rc7-git12-ml (root@atom) (gcc version 4.4.3
(Ubuntu 4.4.3-4ubuntu5) ) #12 SMP Wed May 18 15:54:07 EDT 2011


