Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab2B0HFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:05:22 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:18900
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751421Ab2B0HFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:05:21 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 27 Feb 2012 15:11:51 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/20] pinctrl: Add usecount to pins for muxing
Message-ID: <20120227071150.GA26061@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-18-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329720360-23227-18-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:45:57PM -0700, Stephen Warren wrote:
> Multiple mapping table entries could reference the same pin, and hence
> "own" it. This would be unusual now that pinctrl_get() represents a single
> state for a client device, but in the future when it represents all known
> states for a device, this is quite likely. Implement reference counting
> for pin ownership to handle this.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>  	/*
> -	 * If there is no kind of request function for the pin we just assume
> -	 * we got it by default and proceed.
> -	 */
> +	* If there is no kind of request function for the pin we just assume
> +	* we got it by default and proceed.
> +	*/
I remember the correct format for multiple lines of comments is:
/*
 * ...
 */

But i see the changes here are(i'm using mutt):
/*
* ...
*/
Can you help explain?

Else please also take my ACK:
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

