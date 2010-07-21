Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0GUNha (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 09:37:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:57802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab0GUNh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 09:37:29 -0400
Message-Id: <8u3s94$g0j0tc@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,238,1278313200"; 
   d="scan'208";a="537494456"
Date: Wed, 21 Jul 2010 14:37:23 +0100
To: tim.gardner@canonical.com, Dave Airlie <airlied@redhat.com>
Subject: re: i915 boot regression on Q35 chipset with 2.6.35-rc4
Cc: jbarnes@virtuousgeek.org, eric@anholt.net, Kees Cook <kees@canonical.com>,
        linux-kernel@vger.kernel.org, Gordon Jin <gordon.jin@intel.com>
References: <4C46E98A.3010206@mail.tpi.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4C46E98A.3010206@mail.tpi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 14:35:22 +0200, Tim Gardner <tcanonical@tpi.com> wrote:
> What's up with this patch? I haven't received any comment, nor has it 
> appeared in your git repository.

Dave hasn't taken it because it is a regression fix for i915 and the
current procedure is for those to go through Eric's tree. Eric has been
busy working on a new compiler for GLSL the last few weeks and has been
applying patches in batches.

The patch I am happy to ack, but since I introduced the regression 
[https://bugzilla.kernel.org/show_bug.cgi?id=16294], I'd rather have
someone more familiar with the intricacies of G33/G35/Q35 review it.

For what is worth:
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

-- 
Chris Wilson, Intel Open Source Technology Centre
