Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2HAT6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:58:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37112 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2HAT6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:58:22 -0400
Message-ID: <50198A5C.2030505@wwwdotorg.org>
Date: Wed, 01 Aug 2012 13:58:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: irq: Only update mask bits when doing initial
 mask
References: <1343849377-24030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1343849377-24030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 01:29 PM, Mark Brown wrote:
> Don't write the full register, it's possible there's bits other than the
> masks in the same register which we shouldn't be changing.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Tested-by: Stephen Warren <swarren@wwwdotorg.org>

