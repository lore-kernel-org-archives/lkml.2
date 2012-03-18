Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab2CRUxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 16:53:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57061 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2CRUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 16:53:51 -0400
Date: Sun, 18 Mar 2012 21:54:28 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Joe Perches <joe@perches.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH V2] i915: Add and use pr_fmt and pr_<level>
Message-ID: <20120318205428.GA22726@phenom.ffwll.local>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <7abee2f1eaa52183aad01bacc8179b29ace7f173.1331959343.git.joe@perches.com>
 <20120318193939.GL4286@phenom.ffwll.local>
 <1332100811.23125.22.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332100811.23125.22.camel@joe2Laptop>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 01:00:11PM -0700, Joe Perches wrote:
> Use a more current logging style.  Ensure that appropriate
> logging messages are prefixed with "i915: ".
> 
> Convert printks to pr_<level>.  Align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
