Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2B2KY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:24:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:27494 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756088Ab2B2KY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:24:26 -0500
Message-Id: <aefc95$3boor4@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="113009508"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: i915 drm crashes with link to relevant i915_error_state
To: David Feuer <david.feuer@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CAMgWh9tRJ45+X0iuTWXOLeohADi_fbd68e8-cAAroHr2QvyZmQ@mail.gmail.com>
References: <CAMgWh9tRJ45+X0iuTWXOLeohADi_fbd68e8-cAAroHr2QvyZmQ@mail.gmail.com>
Date: Wed, 29 Feb 2012 10:23:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012 02:48:07 -0500, David Feuer <david.feuer@gmail.com> wrote:
> I've put up the i915_error_state at
> http://techhouse.org/~dfeuer/i915_error_state to (hopefully) allow
> this message to go through.

[snip]

> I got these two incidents running supertuxkart, which is my favorite
> way to generate drm crashes. fgfs (flight sim) and blender (3d
> graphics editor) are quite efficient for that too, though much less so
> than in previous kernel versions.

Please file a bug report against Mesa/i965 on bugzilla.freedesktop.org.
The kernel is reporting that the userspace GL driver has caused the GPU
to execute an invalid program.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
