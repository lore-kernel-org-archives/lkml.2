Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1KPKPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:15:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44144 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736Ab1KPKPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:15:33 -0500
Date: Wed, 16 Nov 2011 10:16:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Rob Clark <rob.clark@linaro.org>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20111116101623.7a59b686@lxorguk.ukuu.org.uk>
In-Reply-To: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/staging/gma500/framebuffer.c: In function 'psb_framebuffer_init':
> drivers/staging/gma500/framebuffer.c:297:2: warning: passing argument 2 of 'drm_helper_mode_fill_fb_struct' from incompatible pointer type [enabled by default]
> include/drm/drm_crtc_helper.h:121:12: note: expected 'struct drm_mode_fb_cmd2 *' but argument is of type 'struct drm_mode_fb_cmd *'
> drivers/staging/gma500/framebuffer.c:564:2: warning: passing argument 2 of 'psb_framebuffer_create' from incompatible pointer type [enabled by default]
> drivers/staging/gma500/framebuffer.c:314:32: note: expected 'struct drm_mode_fb_cmd *' but argument is of type 'struct drm_mode_fb_cmd2 *'

gma500 is frozen pending Dave Airlie's applying the patches moving it out
of staging.

<Prod, prod>

Alan
