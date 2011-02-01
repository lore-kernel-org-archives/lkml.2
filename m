Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab1BARqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 12:46:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:33059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1BARqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:46:20 -0500
Message-Id: <0d30dc$kuat3i@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,411,1291622400"; 
   d="scan'208";a="702903410"
Date: Tue, 01 Feb 2011 17:46:05 +0000
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
Cc: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        linux-kernel@vger.kernel.org
References: <849307$bc24ct@azsmga001.ch.intel.com> <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LSU.2.00.1102010909270.1586@sister.anvils>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.LSU.2.00.1102010909270.1586@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Feb 2011 09:34:12 -0800 (PST), Hugh Dickins <hughd@google.com> wrote:
> Thanks a lot for devising this, Chris, I really appreciate it.
> 
> But so far I can't be more enthusiastic than "seems to be a good
> improvement most of the time" - though I've not spent long on this
> laptop since putting it on to -rc3.

Yeah, this is really just an interim patch. Removes one instance of doing
work when we don't need to, but it does not answer why the vblank patches
made your machines worse (since the same spurious interrupt bug is present
in 2.6.37 and earlier).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
