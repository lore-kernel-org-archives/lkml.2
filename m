Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1EPMTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:19:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47191 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab1EPMTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:19:08 -0400
Message-ID: <4DD11633.6020302@ti.com>
Date: Mon, 16 May 2011 13:18:59 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH] regulator: If we can't configure optimum mode we're always
 in the best one
References: <1305397185-22024-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1305397185-22024-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/11 19:19, Mark Brown wrote:
> If either a regulator driver can't tell us what the optimum mode is (or
> doesn't have modes in the first place) or the system doesn't allow DRMS
> changes then it's more helpful for users to just say that we're in the
> optimal mode, even if it's from a selection of one.
> 
> Still report errors if the process of picking and setting a mode changes as
> this may indicate that we're stuck in a low power mode and unable to deliver
> a higher current that the consumer just asked for.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 

Applied.

Thanks

Liam
