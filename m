Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1KTVUj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 16:20:39 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44621 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab1KTVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 16:20:36 -0500
MIME-Version: 1.0
In-Reply-To: <86aa7sklos.fsf@sumi.keithp.com>
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <CAC7LmnuWLA1LFQa-Vg4StOryo_wd1KjwaQ7m+Yb8Nhek7f=Qjw@mail.gmail.com> <86aa7sklos.fsf@sumi.keithp.com>
From: Eugeni Dodonov <eugeni@dodonov.net>
Date: Sun, 20 Nov 2011 19:19:55 -0200
X-Google-Sender-Auth: CQIREXbdL8vGJ0FRCG3BxZAIDIc
Message-ID: <CAC7Lmnv=bHN+QVDh7PWWEY0s41fNTgxo4eQFBORs3ky48Av6XA@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when reasonable
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 16:32, Keith Packard <keithp@keithp.com> wrote:
> On Sat, 19 Nov 2011 07:25:09 -0200, Eugeni Dodonov <eugeni@dodonov.net> wrote:
>
>> Just one question I caught on 2nd read. Shouldn't we have #else within
>> this #ifdef block, to return 1? Otherwise, if CONFIG_INTEL_IOMMU is
>> not defined, we'll always disable rc6.
>
> Oops! Thanks for catching this. Here's a new version of that function
> (the rest of the patch is the same). This one has explicit conditions
> for Ironlake and Sandybridge (when CONFIG_INTEL_IOMMU is set), allowing
> the Ivybridge and Sandybridge-without-IOMMU cases to take the default
> path. This will also cause all future chips to enable rc6 by default.

Great, I think it catches all cases now.

Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>

Thanks!

-- 
Eugeni Dodonov
