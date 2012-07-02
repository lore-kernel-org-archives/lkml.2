Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab2GBTqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 15:46:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429Ab2GBTqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 15:46:43 -0400
Message-ID: <4FF1FA95.7000404@redhat.com>
Date: Mon, 02 Jul 2012 15:46:29 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/12.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Sven Joachim <svenjoac@gmx.de>, dri-devel@lists.freedesktop.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Bogus video resolution in Linux 3.5-rc4
References: <874npzebev.fsf@turtle.gmx.de> <s5ha9zr8k2f.wl%tiwai@suse.de> <87obo7jnmn.fsf@turtle.gmx.de> <s5ha9zr2o1a.wl%tiwai@suse.de> <87r4t3w59r.fsf@turtle.gmx.de> <s5hsjdi1qtv.wl%tiwai@suse.de>
In-Reply-To: <s5hsjdi1qtv.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/12 3:21 AM, Takashi Iwai wrote:

> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] drm: edid: Don't add inferred modes with higher resolution
>
> When a monitor EDID doesn't give the preferred bit, driver assumes
> that the mode with the higest resolution and rate is the preferred
> mode.  Meanwhile the recent changes for allowing more modes in the
> GFT/CVT ranges give actually more modes, and some modes may be over
> the native size.  Thus such a mode would be picked up as the preferred
> mode although it's no native resolution.
>
> For avoiding such a problem, this patch limits the addition of
> inferred modes by checking not to be greater than other modes.
> Also, it checks the duplicated mode entry at the same time.

This is a little aggressive on CRTs, but whatever, better than what's there.

Reviewed-by: Adam Jackson <ajax@redhat.com>

- ajax
