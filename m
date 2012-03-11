Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2CKXGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 19:06:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59110 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab2CKXGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 19:06:33 -0400
Date: Sun, 11 Mar 2012 16:06:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] drivers/input/touchscreen/hp680_ts_input.c: ensure
 arguments to request_irq and free_irq are compatible
Message-ID: <20120311230626.GA5584@core.coreip.homeip.net>
References: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
 <1331494587-12196-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331494587-12196-7-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 08:36:26PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Change 0 to NULL in the last argument of request_irq, since the argument
> should have pointer type and so that the last argument of request_irq
> syntactically matches the second argument of the later call to free_irq.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied, thanks Julia.

-- 
Dmitry
