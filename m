Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647Ab2D0P0D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:26:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55145 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632Ab2D0P0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:26:01 -0400
Message-ID: <4F9ABA84.3070506@wwwdotorg.org>
Date: Fri, 27 Apr 2012 09:25:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, cjb@laptop.org,
        b20223@freescale.com
Subject: Re: [PATCH v5 1/1] dt: add of_get_child_count helper function
References: <20120427032831.GE26070@shlinux2.ap.freescale.net> <1335497780-1164-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1335497780-1164-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 09:36 PM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> Currently most code to get child count in kernel are almost same,
> add a helper to implement this function for dt to use.
> 
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
