Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1AVWY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:24:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52556 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1AVWY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RgG7RTzkWYEAGu7J0SBjLjypwe4mjYdckjFrVA111//8ZsJke62Z4gyGJbe0uPHWto
         HKT3wsRm2QEU+58Ya/Rfsc/oVeeXEfDp6kaJJWMI1eEsvz7rgNRx2PxNACWiQOBI0oCD
         wF/TKcnHQ3EQAxHdWPQZQMhkIkbpBNB7kFCps=
Message-ID: <4D3B5915.7060206@gmail.com>
Date: Sat, 22 Jan 2011 23:24:21 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Dave Airlie <airlied@linux.ie>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Fix use of invalid array size for ring->sync_seqno
References: <4D39455D.4070808@gmail.com> <1295604715-24563-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295604715-24563-1-git-send-email-chris@chris-wilson.co.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2011 11:11 AM, Chris Wilson wrote:
> There are I915_NUM_RINGS-1 inter-ring synchronisation counters, but we
> were clearing I915_NUM_RINGS of them. Oops.
> 
> Reported-by: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
> 
> Jiri, does this catch the invalid array access? For 3 rings, there should
> only be 2 sync counters...

Yup, it's gone.

thanks,
--
js
