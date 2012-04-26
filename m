Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab2DZPRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:17:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51494 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2DZPRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:17:37 -0400
Message-ID: <4F99670E.8080307@wwwdotorg.org>
Date: Thu, 26 Apr 2012 09:17:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de
Subject: Re: [PATCH v4 1/1] pinctrl: add pinctrl_provide_dummies interface
 for platforms to use
References: <1335428150-12629-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1335428150-12629-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 02:15 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Add a interface pinctrl_provide_dummies for platform to indicate
> whether it needs use pinctrl dummy state.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
