Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab2EWOwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:52:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50856 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2EWOwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:52:32 -0400
Message-ID: <4FBCF9AD.4010409@wwwdotorg.org>
Date: Wed, 23 May 2012 08:52:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: fix a minor harmless typo
References: <Pine.LNX.4.64.1205230019070.11851@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1205230019070.11851@axis700.grange>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 04:20 PM, Guennadi Liakhovetski wrote:
> The way the for_each_maps() macro is currently used, using "i" instead of
> "_i_" works and is harmless. Still, this is a bug, that can trigger any
> time, if the code around that macro changes. Better fix it now.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Clearly correct,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
