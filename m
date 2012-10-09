Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2JICVO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:21:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39934 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2JICVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:21:12 -0400
Message-ID: <50738A17.9010201@wwwdotorg.org>
Date: Mon, 08 Oct 2012 20:21:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: linus.walleij@linaro.org
CC: Wei Yongjun <weiyj.lk@gmail.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, yongjun_wei@trendmicro.com.cn,
        linux-rpi-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: remove duplicated include from pinctrl-bcm2835.c
References: <CAPgLHd-C5NvpG7vo68kAjY4+CxDXenYU-Po-K4Z+uuvz_vZpxg@mail.gmail.com>
In-Reply-To: <CAPgLHd-C5NvpG7vo68kAjY4+CxDXenYU-Po-K4Z+uuvz_vZpxg@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2012 07:28 AM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)

Linus, I assume this will go through the pinctrl tree?
