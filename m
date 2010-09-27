Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab0I0Jvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:51:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:41366 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab0I0Jvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:51:32 -0400
Message-Id: <89k83a$9pqvca@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,242,1283756400"; 
   d="scan'208";a="329088394"
Date: Mon, 27 Sep 2010 10:51:28 +0100
To: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: i915: glxgears causes GPU hang [was: mmotm 2010-09-22-16-11 uploaded]
Cc: akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        daniel.vetter@ffwll.ch
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org> <4CA065B8.1060206@gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4CA065B8.1060206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 11:36:56 +0200, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 09/23/2010 01:12 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
> 
> Hi, when I run glxgears in this kernel, X crashes. It happens also with
> older releases and I don't know what is the first defunct.
> 
> In the log there is:
> [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
> [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5
> (awaiting 2 at 0)

Hmm, that's a serious error as it appears the chip wasn't initialised
correctly and failed to start. G33, this is likely to be
https://bugzilla.kernel.org/show_bug.cgi?id=16891
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
