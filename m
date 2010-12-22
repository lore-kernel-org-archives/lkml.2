Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0LVAJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:09:45 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:62473 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0LVAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:09:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=E5kjnnGfDBg9ZwJmnYmDYXGC8TCovvu91G7QRcPyWSJTVQ7/JNMclC7s+egfEI9XGk
         Zqfxebu0rZZIkrmwNge+Kr+Ocz2B9fuv2hMCtHsGV1hSoJOEcoUZU22NL5ypORoi2GUt
         9xe60O2s2OTVRkuQOFPkqx1GbXTmFiLonZzmc=
Date: Wed, 22 Dec 2010 03:09:39 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c_adc_battery: Add gpio_inverted field to pdata
Message-ID: <20101222000939.GE24834@oksana.dev.rtsoft.ru>
References: <1292235981-9842-1-git-send-email-anarsoul@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1292235981-9842-1-git-send-email-anarsoul@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 12:26:21PM +0200, Vasily Khoruzhick wrote:
> Add support for inverted gpio_charge_finished values.
> This change is necessary for H1940 support.
> 
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>

Applied to battery-2.6.git, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
