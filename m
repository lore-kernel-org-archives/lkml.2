Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab2JIQWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:22:21 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37417 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754311Ab2JIQWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:22:19 -0400
Message-ID: <1349799738.2386.1.camel@joe-AO722>
Subject: Re: [PATCH] Staging: winbond: wbusb: Fixed coding style issue
From: Joe Perches <joe@perches.com>
To: Adil Mujeeb <mujeeb.adil@gmail.com>
Cc: pavel@ucw.cz, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Oct 2012 09:22:18 -0700
In-Reply-To: <1349799055-4496-1-git-send-email-mujeeb.adil@gmail.com>
References: <1349799055-4496-1-git-send-email-mujeeb.adil@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 21:40 +0530, Adil Mujeeb wrote:
> Repalces printk's with pr_debug
[]
> diff --git a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
> index 0ca857a..48fe622 100644
> --- a/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
> +++ b/linux-3.6-rc7/drivers/staging/winbond/wbusb.c
> @@ -79,18 +79,18 @@ static int wbsoft_add_interface(struct ieee80211_hw *dev,
>  static void wbsoft_remove_interface(struct ieee80211_hw *dev,
>  				    struct ieee80211_vif *vif)
>  {
> -	printk("wbsoft_remove interface called\n");
> +	pr_debug("wbsoft_remove interface called\n");

It'd be more consistent to use
	pr_debug("%s called\n", __func__);
everywhere.

It might be even nicer to remove almost all of these.


