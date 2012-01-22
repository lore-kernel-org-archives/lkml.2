Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab2AVQvz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 11:51:55 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:45692 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751961Ab2AVQvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 11:51:53 -0500
Message-ID: <4F1C4C58.6040100@xenotime.net>
Date: Sun, 22 Jan 2012 09:50:16 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
CC: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trivial patch monkey <trivial@kernel.org>, kyle@mcmartin.ca
Subject: Re: [PATCH] [trivial] parisc : Fix typo in eisa_enumerator.c
References: <1327233948-2070-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1327233948-2070-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2012 04:05 AM, Masanari Iida wrote:
> Correct spelling "confgiuration" to "configuration" in
> drivers/parisc/eisa_enumerator.c

Correct trivial email address.

> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/parisc/eisa_enumerator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
> index caa1531..a656d9e 100644
> --- a/drivers/parisc/eisa_enumerator.c
> +++ b/drivers/parisc/eisa_enumerator.c
> @@ -357,7 +357,7 @@ static int parse_slot_config(int slot,
>  		}
>  		if (flags & HPEE_FUNCTION_INFO_CFG_FREE_FORM) {
>  			/* I have no idea how to handle this */
> -			printk("function %d have free-form confgiuration, skipping ",
> +			printk("function %d have free-form configuration, skipping ",

			                    has

>  				num_func);
>  			pos = p0 + function_len;
>  			continue;


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
