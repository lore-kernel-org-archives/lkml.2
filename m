Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2HYR3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:29:01 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:35896 "EHLO
	homiemail-a48.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753533Ab2HYR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=WycbFEaR8uIS0Slml+FxBiCqMZYpRWN4pX3BbYPFL41LM5ZSy5JEOCZIpoFAy
	0NZ1I4XFSmhT+kFNMkkoMrza7jneTFBvkFgpWd+JqD82FgbNPkye84fxZHzaysbi
	ZS/BE20otuiXySy2/0bGFawUydKVsgu7MeYnVLre2rQHwQ=
Message-ID: <50390B54.4040706@shealevy.com>
Date: Sat, 25 Aug 2012 13:28:52 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120703 Thunderbird/11.0.1
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: Add support for Apple vendor-specific devices
References: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
In-Reply-To: <1345915686-3915-1-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/25/2012 01:28 PM, Henrik Rydberg wrote:
> +	/* Apple-specific (Broadcom) devices */
> +	{ USB_VENDOR_AND_INTERFACE_INFO(0x05ac, 0xff, 0x01, 0x01) },
> +
>

Would this subsume https://lkml.org/lkml/2012/8/22/689 ?

Thanks,
Shea Levy
