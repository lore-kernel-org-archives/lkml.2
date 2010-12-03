Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab0LCUrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 15:47:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:54117 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0LCUrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 15:47:12 -0500
Date: Fri, 3 Dec 2010 21:47:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Hounschell <markh@compro.net>, Alex Deucher <alexdeucher@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel tree "diff -urN" anomaly?
Message-ID: <20101203204709.GA17591@merkur.ravnborg.org>
References: <4CF949AF.1000502@compro.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF949AF.1000502@compro.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 02:49:03PM -0500, Mark Hounschell wrote:
> I start with two clean identical 2.6.36.1 kernel trees (different names
> of coarse). I build one of them. I then do a "make clean mrproper" in
> the tree I built. Why then does the diff command in the subject line
> find the following files changed?
> 
> drivers/gpu/drm/radeon/evergreen_reg_safe.h
> drivers/gpu/drm/radeon/r100_reg_safe.h
> drivers/gpu/drm/radeon/r200_reg_safe.h
> drivers/gpu/drm/radeon/r300_reg_safe.h
> divers/gpu/drm/radeon/r420_reg_safe.h
> drivers/gpu/drm/radeon/r600_reg_safe.h
> drivers/gpu/drm/radeon/rn50_reg_safe.h
> drivers/gpu/drm/radeon/rs600_reg_safe.h
> drivers/gpu/drm/radeon/rv515_reg_safe.h

Files are generated during the build.
So after you have build your kernel the files are present.
And the Makefile is missing logic to delete the files during "make clean".

	Sam
