Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0KKIjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 03:39:48 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:46423 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0KKIjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 03:39:47 -0500
Subject: Re: [PATCH] drm/i915: Fix LVDS fixed-mode regression from 219adae1
From: Jon Masters <jonathan@jonmasters.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1289258652-22665-1-git-send-email-chris@chris-wilson.co.uk>
References: <1289257727.3916.429.camel@constitution.bos.jonmasters.org>
	 <1289258652-22665-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Thu, 11 Nov 2010 03:39:27 -0500
Message-ID: <1289464767.3916.596.camel@constitution.bos.jonmasters.org>
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

This is now being tracked at the following k.o BZ:

https://bugzilla.kernel.org/show_bug.cgi?id=22712

Please mark the BZ when you push the patch. Thanks.

Jon.


