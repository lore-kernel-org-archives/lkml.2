Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab2BWVku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:40:50 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59321 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab2BWVkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:40:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.24.202 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F46B169.1030307@intel.com>
References: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
 <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk>
 <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com> <4F46B169.1030307@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 13:40:28 -0800
X-Google-Sender-Auth: Z78RhVUUOd7WB2jFCTpevBVjLbc
Message-ID: <CA+55aFxh=Q=+qm+tj1tfsTZ_3cke-H57Fi2YfX_vgJ=5-T2ueA@mail.gmail.com>
Subject: Re: [PATCH] drm: Reduce the number of retries whilst reading EDIDs
To: Eugeni Dodonov <eugeni.dodonov@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 1:36 PM, Eugeni Dodonov
<eugeni.dodonov@intel.com> wrote:
>
> Perhaps a stupid question, but does you tree has
> http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=9292f37e1f5c79400254dca46f83313488093825
> from Dave's drm-next?
>
> If it has, it would be the 1st time that I see xrandr take longer than .5s
> with that patch on an Intel GPU. We even added a check for this into
> intel-gpu-tools to warn us if any machine takes that long, and none had hit
> it so far. So if this is the case here, there is something Mac Mini-specific
> indeed to investigate.

Yup, the tree I tested was current -git with the two commits mentioned
in this thread:

   drm: Reduce the number of retries whilst reading EDIDs
   drm: give up on edid retries when i2c bus is not responding

applied separately on top of it.

                Linus
