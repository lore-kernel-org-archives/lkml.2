Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1KISOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:14:25 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56722 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1KISOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:14:23 -0500
Date: Wed, 9 Nov 2011 10:14:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] input: ams_delta_serio: include linux/module.h
Message-ID: <20111109181417.GB26633@core.coreip.homeip.net>
References: <1320862005-6049-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320862005-6049-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 08:06:45PM +0200, Aaro Koskinen wrote:
> Fix the following compilation failure with v3.2-rc1 by including module.h:
> 
>   CC      drivers/input/serio/ams_delta_serio.o
> drivers/input/serio/ams_delta_serio.c:33:15: error: expected declaration specifiers or '...' before string constant
> drivers/input/serio/ams_delta_serio.c:34:20: error: expected declaration specifiers or '...' before string constant
> drivers/input/serio/ams_delta_serio.c:35:16: error: expected declaration specifiers or '...' before string constant
> drivers/input/serio/ams_delta_serio.c: In function 'ams_delta_serio_init':
> drivers/input/serio/ams_delta_serio.c:155:2: error: 'THIS_MODULE' undeclared (first use in this function)
> drivers/input/serio/ams_delta_serio.c:155:2: note: each undeclared identifier is reported only once for each function it appears in
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Thank you Aaro.

-- 
Dmitry
