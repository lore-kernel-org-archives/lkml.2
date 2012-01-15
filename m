Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2AOAHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 19:07:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55148 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2AOAHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 19:07:19 -0500
Date: Sun, 15 Jan 2012 01:09:20 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Dave Airlie <airlied@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] gpu, drm, sis: Don't return uninitialized variable from
 sis_driver_load()
Message-ID: <20120115000920.GA5750@phenom.ffwll.local>
Mail-Followup-To: Jesper Juhl <jj@chaosbits.net>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Arjan van de Ven <arjan@linux.intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
References: <alpine.LNX.2.00.1201142117400.11547@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201142117400.11547@swampdragon.chaosbits.net>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 09:20:37PM +0100, Jesper Juhl wrote:
> In sis_driver_load(), the only use of 'ret' is as the return value
> from the function, unfortunately it is never initialized, so the
> function just returns garbage when it succeeds.
> To fix that, remove the variable and just return 0 directly on success.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Woot, not one of mine!

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
