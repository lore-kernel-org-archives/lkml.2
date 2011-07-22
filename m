Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1GVKrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:47:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52802 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1GVKru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:47:50 -0400
Subject: Re: [PATCH] regulator: Fix argument format type errors in error
 prints
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1311257257-26498-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311257257-26498-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:47:47 +0100
Message-ID: <1311331667.3312.12.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-21 at 15:07 +0100, Mark Brown wrote:
> We need to dereference the pointers to print their values.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)


Applied.

Thanks

Liam

