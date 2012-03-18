Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2CRTi6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 15:38:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64650 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2CRTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 15:38:57 -0400
Date: Sun, 18 Mar 2012 20:39:39 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Joe Perches <joe@perches.com>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/2] i915: Add and use pr_fmt and pr_<level>
Message-ID: <20120318193939.GL4286@phenom.ffwll.local>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <7abee2f1eaa52183aad01bacc8179b29ace7f173.1331959343.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7abee2f1eaa52183aad01bacc8179b29ace7f173.1331959343.git.joe@perches.com>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 09:43:49PM -0700, Joe Perches wrote:
> Use a more current logging style.  Ensure that appropriate
> logging messages are prefixed with "i915: ".
> 
> Convert printks to pr_<level>.  Align arguments.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I've tried to apply this to my -next branch, but it failed. Can you please
rebase this onto

http://cgit.freedesktop.org/~danvet/drm-intel/log/?h=drm-intel-next-queued

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
