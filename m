Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab0LMXJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 18:09:45 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51755 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0LMXJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 18:09:44 -0500
Message-ID: <4D06A7B1.6060609@canonical.com>
Date: Mon, 13 Dec 2010 15:09:37 -0800
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Input: synaptics - add multitouch packet support
References: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1292280948-1933-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 02:55 PM, Henrik Rydberg wrote:
> @@ -638,7 +677,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>  	__set_bit(BTN_LEFT, dev->keybit);
>  	__set_bit(BTN_RIGHT, dev->keybit);
>  
> -	if (SYN_CAP_MULTIFINGER(priv->capabilities)) {
> +	if (SYN_CAP_MULTIFINGER(priv->capabilities) | priv->multitouch) {

^^ Although I think this is functionally correct, it is nevertheless a
typo. Note that there's only one '|' where there should be two.

Henrik, do you want to fix this, or would you like me to fix and resend?
I've got no problems either way :).

Thanks,

-- Chase
