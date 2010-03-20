Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0CTAQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 20:16:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41595 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752440Ab0CTAQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 20:16:48 -0400
Date: Sat, 20 Mar 2010 01:16:34 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sankar P <sankar.curiosity@gmail.com>
Cc: gregkh@suse.de, penberg@cs.helsinki.fi, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] staging: winbond: Remove typedef for standard types
Message-ID: <20100320001633.GE1477@ucw.cz>
References: <1269031264-2327-1-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-2-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-3-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-4-git-send-email-sankar.curiosity@gmail.com> <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269031264-2327-5-git-send-email-sankar.curiosity@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2010-03-20 02:11:02, Sankar P wrote:
> Remove the typedef named "fixed" used for the standard type s32
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

NAK. That actually makes sense.


> -/****************** LOCAL TYPE DEFINITION SECTION ***************************/
> -typedef s32         fixed; /* 16.16 fixed-point */
> -
> -static const fixed Angles[]=
> +static const s32 Angles[] =

fixed points are very different from integers...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
