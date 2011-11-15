Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1KOV0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:26:46 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:56301 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932415Ab1KOV0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:26:45 -0500
Message-ID: <4EC2D8AA.6080701@xenotime.net>
Date: Tue, 15 Nov 2011 13:24:58 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rajendra Nayak <rnayak@ti.com>
CC: linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCH] Documentation: Fix minor typos in pinctrl.txt
References: <1321335378-29064-1-git-send-email-rnayak@ti.com>
In-Reply-To: <1321335378-29064-1-git-send-email-rnayak@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 09:36 PM, Rajendra Nayak wrote:
> Fix some minor typos in the pinctrl documentation.
> 
> Signed-off-by: Rajendra Nayak <rnayak@ti.com>
> ---
>  Documentation/pinctrl.txt |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
> index b04cb7d..c849a09 100644
> --- a/Documentation/pinctrl.txt
> +++ b/Documentation/pinctrl.txt
> @@ -91,7 +91,7 @@ int __init foo_probe(void)
>  Pins usually have fancier names than this. You can find these in the dataheet

fix typo:                                                               datasheet

>  for your chip. Notice that the core pinctrl.h file provides a fancy macro
>  called PINCTRL_PIN() to create the struct entries. As you can see I enumerated
> -the pins from 0 in the upper left corner to 63 in the lower right corner,
> +the pins from 0 in the lower left corner to 63 in the upper right corner,

fix run-on sentences:

   the pins from 0 in the lower left corner to 63 in the upper right corner.
   This enumeration was arbitrarily chosen; in practice you need to think

>  this enumeration was arbitrarily chosen, in practice you need to think
>  through your numbering system so that it matches the layout of registers
>  and such things in your driver, or the code may become complicated. You must


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
