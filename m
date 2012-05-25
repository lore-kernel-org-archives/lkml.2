Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2EYQus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:50:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58040 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2EYQur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:50:47 -0400
Message-ID: <4FBFB863.7060601@wwwdotorg.org>
Date: Fri, 25 May 2012 10:50:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com
Subject: Re: [PATCH v4 5/6] of: add of_parse_phandle_with_args_ext function
References: <1337952980-14621-1-git-send-email-b29396@freescale.com> <1337952980-14621-5-git-send-email-b29396@freescale.com>
In-Reply-To: <1337952980-14621-5-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 07:36 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The api is used when user wants to get some more extended args except ones
> indicated by the cells_name.
> For example, gpio cells is 2.
> list = <&gpio 1 2 3 4>;

I assume either that property should be named "gpios", or ...

> If users want to get extended args including 3, 4, he can call:
> of_parse_phandle_with_args_ext(np, "gpios", "#gpio-cells", index, 2, &outargs);

The second parameter above should be "list".
