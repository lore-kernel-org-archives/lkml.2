Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1BYJA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:00:28 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55485 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab1BYJA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:00:27 -0500
Subject: Re: [PATCH] regulator: If we fail when setting up a supply say
 which supply
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
In-Reply-To: <1298569149-9169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1298569149-9169-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 09:00:22 +0000
Message-ID: <1298624422.3363.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 17:39 +0000, Mark Brown wrote:
> Makes it a bit easier to identify if it's a problem with the supplies,
> the usual error would be omitting the supply name entirely.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)

Applied.

Thanks

Liam

