Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0H2F6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 01:58:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49111 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0H2F6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 01:58:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e5jK4xqXbJylRqZfapJ1WTt5oHW3iJZvP8luJVvMQtFrWJ9av+vbbWknoDNEOfj6pI
         4L5mg8q++MTFFtPXyX9G8+Iab69NXFAUUMZfrkNpyMhRHep08skp+RCxEs4xn/POIRWw
         beM/6eZfQDYq7+tWSrK/Qq3kRL/uA71GhaHLI=
Date: Sat, 28 Aug 2010 22:58:41 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] input: mt: Initialize slots to unused
Message-ID: <20100829055840.GD15369@core.coreip.homeip.net>
References: <1282484809-8554-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282484809-8554-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 03:46:49PM +0200, Henrik Rydberg wrote:
> For MT slots, the ABS_MT_TRACKING_ID determines whether a slot is in use,
> but currently leaves initialization up to the drivers. This patch sets the
> slot state to unused upon creation.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied (which change to for() loop - I prefer not change passed
arguments), thanks Henrik.

-- 
Dmitry
