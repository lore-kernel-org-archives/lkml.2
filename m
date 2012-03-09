Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2CIE1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 23:27:48 -0500
Received: from void.printf.net ([89.145.121.20]:55570 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab2CIE1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 23:27:47 -0500
From: Chris Ball <cjb@laptop.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Ben Dooks <ben-linux@fluff.org>, kernel-janitors@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/host/sdhci-s3c.c: use devm_ functions
References: <1329596019-19822-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Thu, 08 Mar 2012 23:27:41 -0500
In-Reply-To: <1329596019-19822-1-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Sat, 18 Feb 2012 21:13:39 +0100")
Message-ID: <m2k42uqtz6.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/24.0.94 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Sat, Feb 18 2012, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.
>
> By using devm_ioremap, it also removes a potential memory leak, because
> there was no call to iounmap in the probe function.
>
> The call to platform_get_resource was moved just to make it closer to the
> place where its result it used.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks very much, pushed to mmc-next for 3.4.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
