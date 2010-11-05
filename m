Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab0KEPNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 11:13:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53737 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab0KEPNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 11:13:14 -0400
Message-ID: <4CD41E9D.2000702@ru.mvista.com>
Date: Fri, 05 Nov 2010 18:11:25 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@nokia.com>
CC: cbouatmailru@gmail.com, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com
Subject: Re: [PATCH 4/4] power_supply: isp1704: Detect charger after probe
References: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com> <1288881109-18222-5-git-send-email-heikki.krogerus@nokia.com>
In-Reply-To: <1288881109-18222-5-git-send-email-heikki.krogerus@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 04-11-2010 17:31, Heikki Krogerus wrote:

> If the device is booted up with cable connected, or the
> module is loaded after plugging in the cable, the
> notification has come and gone, so not relying on it at
> probe time. Instead this checks the VBUS level manually
> after probe.

> Signed-off-by: Heikki Krogerus<heikki.krogerus@nokia.com>
> ---
>   drivers/power/isp1704_charger.c |   17 +++++++++++++++++
>   1 files changed, 17 insertions(+), 0 deletions(-)

> diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
> index 77c11f1..946e43c 100644
> --- a/drivers/power/isp1704_charger.c
> +++ b/drivers/power/isp1704_charger.c
> @@ -422,6 +422,23 @@ static int __devinit isp1704_charger_probe(struct platform_device *pdev)
>
>   	dev_info(isp->dev, "registered with product id %s\n", isp->model);
>
> +	/*
> +	 * Taking over the D+ pullup.
> +	 *
> +	 * FIXME: The device will be disconnected if the it was already
                                                      ^^^
    "the" is not needed here.

WBR, Sergei
