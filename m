Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab0DAKki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:40:38 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58080 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab0DAKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MVNlCr6YTW9La9SKXsRruQcxP5jCJ+3KypYLOiPuCygD3SdDNV8YUnXbZIkA41HJFK
         UDi8TgbkfNWtR+XDRvIFAgLcxt5aGwEQ/NFvmrm8saQMVC0Xdc/7XNq7Vm7jB2WOM8KZ
         EkrnXwlhdqSQNWloeDsyMxUIBjeQWalfGcij4=
Date: Thu, 1 Apr 2010 14:40:21 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryan Mallon <ryan@bluewatersys.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] power/ds2782: fix clientdata on removal
Message-ID: <20100401104021.GA30121@oksana.dev.rtsoft.ru>
References: <1270117664-29099-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1270117664-29099-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:27:44PM +0200, Wolfram Sang wrote:
> Probably due to a copy & paste bug, clientdata was set again to the data
> structure (which is freed immediately afterwards) when it should be
> NULLed. Just remove the calls as the i2c-core does this automatically
> now.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Ryan Mallon <ryan@bluewatersys.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> ---
>
> Anton: If it is okay with you, I think this should go via the I2C-tree to
> ensure it comes after the needed modification of the i2c-core.

Sure thing.

Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!
