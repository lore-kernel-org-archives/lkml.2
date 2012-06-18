Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab2FRSFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 14:05:24 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39957 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2FRSFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 14:05:22 -0400
Message-ID: <4FDF6DDE.3020306@wwwdotorg.org>
Date: Mon, 18 Jun 2012 12:05:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Devendra Naga <devendra.aaru@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl/pinctrl-tegra: remove IS_ERR checking of
 pmx->pctl
References: <1340041471-30122-1-git-send-email-devendra.aaru@gmail.com>
In-Reply-To: <1340041471-30122-1-git-send-email-devendra.aaru@gmail.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 11:44 AM, Devendra Naga wrote:
> pinctrl_register returns a pointer of struct type struct pinctrl_dev,
> if successfully registered to pinctrl subsystem, otherwise returns
> NULL, and there wont' be any pointers which are not dereferencible.
> 
> They are not type of pointer addresses but are kind of error
> codes rather actual addresses, but are a kind of return
> codes of functions returning integer types.
> 
> return -ENODEV if device registration fails.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Oops.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

Probably Cc stable since this is wrong back as far as 3.4.
