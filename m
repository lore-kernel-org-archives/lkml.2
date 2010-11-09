Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab0KIAP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 19:15:56 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:40058 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab0KIAPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 19:15:55 -0500
Subject: Re: [PATCH] drm/i915: Fix LVDS fixed-mode regression from 219adae1
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1289258652-22665-1-git-send-email-chris@chris-wilson.co.uk>
References: <1289257727.3916.429.camel@constitution.bos.jonmasters.org>
	 <1289258652-22665-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Mon, 08 Nov 2010 19:16:08 -0500
Message-ID: <1289261768.3916.434.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-08 at 23:24 +0000, Chris Wilson wrote:
> Commit 219adae1 cached the EDID found during LVDS init, but in the
> process prevented the init routine from discovering the preferred
> fixed-mode for the panel. This was causing us to guess the correct mode,
> which sometimes is wide of the mark.
> 
> Reported-by: Jon Masters <jonathan@jonmasters.org>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

I have tested this patch, and my LVDS panel display on this Eee PC
1015PEM is now working correctly :) Obviously I suspect others will be
affected in due course, so hopefully this can make the next 2.6.37 RC.

Please add my:

Tested-by: Jon Masters <jonathan@jonmasters.org>

To this patch also.

Jon.


