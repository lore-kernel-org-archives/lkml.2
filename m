Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750916Ab1DTEXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 00:23:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37336 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1DTEXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 00:23:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oiW87UCiNi7jLIPsn/AT+7LAYfHOqv0NAYyQTJi9pdBH9iZ8swuIbScjYXx9vUGGIn
         Hdo8veUmKu87TEo/lU+X63lqgcLo8ajjQskyMLKV9mMKjed1zCetIW5qQ6pHWtgTh70y
         vODXetcYfW+gYB7t/oAj8JP261Zt4pZ+9O3jE=
MIME-Version: 1.0
In-Reply-To: <20110419174712.GA29314@pengutronix.de>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
	<20110419102031.GA4164@pengutronix.de>
	<BANLkTinfhb3vejJSM4y-C=3vk5RE76gPjQ@mail.gmail.com>
	<20110419174712.GA29314@pengutronix.de>
Date: Wed, 20 Apr 2011 13:23:04 +0900
X-Google-Sender-Auth: QFJEmFWO2RB1PoKB2yj5p75aXa8
Message-ID: <BANLkTinv84Ci1BUAGAXSDc-VYWGs8fC4fA@mail.gmail.com>
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
From: Kyungmin Park <kmpark@infradead.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org,
        sameo@linux.intel.com, patches@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?7KCV7J6s7ZuI?= <jh80.chung@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 2:47 AM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>> BTW, Are there reason to omit the sdhci-s3c.c? Maybe Mr. Jung will handle it.
>
> The difference is that sdhci-s3c.c was more like a fork of sdhci-pltfm while
> the others were users of it. With the new interface, s3c can be converted using
> pltfm more easily. If somebody is willing to do that, this is very much
> welcome. I'd suggest waiting for Shawn's interface to stabilize, though.
Okay Thanks, we will prepare it.
>
> Regards,
>
>   Wolfram
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
