Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab2LNWwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:52:09 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33381 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2LNWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:52:07 -0500
Message-ID: <50CBAD95.3090308@wwwdotorg.org>
Date: Fri, 14 Dec 2012 15:52:05 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Julien Delacou <julien.delacou@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2 v2] pinctrl/nomadik: adopt pinctrl sleep mode management
References: <1355516472-24759-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1355516472-24759-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 01:21 PM, Linus Walleij wrote:
> This fix makes pinctrl-nomadik able to handle
> suspend/resume events and change hogged pins states
> accordingly.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
