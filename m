Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab1C3TOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:14:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51586 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1C3TOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:14:51 -0400
Subject: Re: [PATCH] regulator: When constraining modes fall back to higher
 power modes
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Collins <collinsd@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1301434152-16393-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1301434152-16393-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 20:14:45 +0100
Message-ID: <1301512485.3375.33.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 06:29 +0900, Mark Brown wrote:
> If a mode requested by a consumer is not allowed by constraints
> automatically fall back to a higher power mode if possible. This
> ensures that consumers get at least the output they requested while
> allowing machine drivers to transparently limit lower power modes
> if required.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---

Applied.

Thanks

Liam

