Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab2ENXbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:31:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58731 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2ENXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:31:43 -0400
Message-ID: <4FB195DC.3010905@wwwdotorg.org>
Date: Mon, 14 May 2012 17:31:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, haojian.zhuang@marvell.com,
        shawn.guo@freescale.com
Subject: Re: [PATCH 1/5] pinctrl: a minor error checking improvement for pinconf
References: <1336993600-30065-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1336993600-30065-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 05:06 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Also checking invalid num_configs when validate the pinconf map.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

The series,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
