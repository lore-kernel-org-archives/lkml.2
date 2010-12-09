Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376Ab0LIU5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:57:50 -0500
Received: from mail-yx0-f194.google.com ([209.85.213.194]:61232 "EHLO
	mail-yx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020Ab0LIU5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:57:48 -0500
X-Greylist: delayed 7680 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 15:57:47 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=J4FgE7DsbFWl1CaJXvGZ63d22nrohVwVRBxDsUrxvfGGXL0UIa946bXRqNiLos9Wl2
         rfotfZDloiHwRH2NAUkoFuPy1ICPEcQPncTCBFKMwYd0QPrKQXZKxdRh2TkRBX/6r1OS
         aazR9bGNk/9lOev2+Op2SczzMCfJrJDGlxyt4=
Date: Thu, 9 Dec 2010 12:57:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: mt: Move input MT header inside input directory
Message-ID: <20101209205737.GE23781@core.coreip.homeip.net>
References: <1291925117-22042-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291925117-22042-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 09:05:17PM +0100, Henrik Rydberg wrote:
> As a clean-up, rename the input-mt.h header to
> input/mt.h. The patch contains no functional changes.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Thanks for making the change Henrik.

Acked-by: Dmitry Torokhov <dtor@mail.ru>

-- 
Dmitry
