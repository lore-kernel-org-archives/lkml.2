Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab0JZMlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:41:09 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:38272 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756176Ab0JZMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:41:07 -0400
Date: Tue, 26 Oct 2010 14:36:50 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Julia Lawall <julia@diku.dk>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/14] drivers/video/omap/blizzard.c: delete double
 assignment
Message-ID: <20101026143650.14c836eb@absol.kitzblitz>
In-Reply-To: <1288088743-3725-13-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
	<1288088743-3725-13-git-send-email-julia@diku.dk>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Julia Lawall <julia@diku.dk>:
> Delete successive assignments to the same location.  Initialize the out_y
> field as well as the out_x field, rather than initializing the out_x field
> twice.

Hi there!

An identical patch is already in the -mm tree:

> The patch titled
>      drivers/video/omap/blizzard.c: suspected typo in assignment
> has been added to the -mm tree.  Its filename is
>      video-omap-suspected-typo-in-assignment.patch

> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: drivers/video/omap/blizzard.c: suspected typo in assignment
> From: Nicolas Kaiser <nikai@nikai.net>
> 
> Untested, but looks like an obvious typo to me.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Best regards,
Nicolas Kaiser
