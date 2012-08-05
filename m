Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab2HEVTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:19:36 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:24575 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2HEVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:19:35 -0400
Date: Sun, 5 Aug 2012 23:19:34 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Daniel Vetter <daniel@ffwll.ch>
cc: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: Fix mem leak in intel_sdvo_write_cmd()
In-Reply-To: <20120805210044.GE12232@phenom.ffwll.local>
Message-ID: <alpine.LNX.2.00.1208052319010.25703@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207312228270.7100@swampdragon.chaosbits.net> <20120805210044.GE12232@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Aug 2012, Daniel Vetter wrote:

> On Tue, Jul 31, 2012 at 10:31:15PM +0200, Jesper Juhl wrote:
> > If the allocation of 'buf' succeeds but the allocation of 'msgs' fails
> > we'll return false and leak 'buf' when it goes out of scope.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> I've already merged a similar patch from Alan Cox for -fixes, should land
> in 3.6 soonish.

Perfect.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

