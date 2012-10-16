Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2JPPsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 11:48:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55327 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2JPPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 11:48:15 -0400
Message-ID: <507D81BB.4020006@wwwdotorg.org>
Date: Tue, 16 Oct 2012 09:48:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [PATCH 1/1] Documentation: Describe Device Tree bindings for
 GPIO Regulator driver
References: <1350374553-12678-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1350374553-12678-1-git-send-email-lee.jones@linaro.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2012 02:02 AM, Lee Jones wrote:
> Here we specify all non-standard bindings which can be used when
> requesting the use of an GPIO controlled regulator from Device Tree.

FWIW since I commented on this before and accidentally noticed the
repost, the binding looks fine to me now. So, this patch,

Reviewed-by: Stephen Warren <swarren@nvidia.com>
