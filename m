Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0LEVnH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 16:43:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:20062 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab0LEVnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 16:43:06 -0500
Message-Id: <b9dded$h9rt4c@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,302,1288594800"; 
   d="scan'208";a="580777100"
Date: Sun, 05 Dec 2010 21:43:02 +0000
To: Sriram <sri.kmb@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [drm:init_ring_common] *ERROR* render ring head not reset to zero
In-Reply-To: <loom.20101205T072655-971@post.gmane.org>
References: <201010042231.20320.thomas@m3y3r.de> <8u3s8d$jp78ts@orsmga001.jf.intel.com> <loom.20101205T072655-971@post.gmane.org>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Dec 2010 06:28:25 +0000 (UTC), Sriram <sri.kmb@gmail.com> wrote:
> Please explain what this error means & why it is happening...

We wrote a zero into the register (whilst the ring is completely idle,
supposedly anyway) and read back a non-zero value. We believe the silicon
is doing evil things, we workaround it by writing the value again, and
continue on our merry way.

The dance only gets more complex as the hardware evolves.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
