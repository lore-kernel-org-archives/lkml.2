Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab1FTKDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:33014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206Ab1FTKDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:03:32 -0400
Message-ID: <4DFF1AA5.80508@ru.mvista.com>
Date: Mon, 20 Jun 2011 14:02:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-arm-kernel@lists.infradead.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH][Trivial] S3C2410 bluetooth: Remove duplicate linux/leds.h
 include
References: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1106201035590.18991@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [140.211.167.34]); Mon, 20 Jun 2011 10:03:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 20-06-2011 12:40, Jesper Juhl wrote:

> Remove the duplicate inclusion of linux/leds.h from
> arch/arm/mach-s3c2410/h1940-bluetooth.c that was added by commit 50e2d10d.

    Pelase also specify that commit's summary in parens.

> Signed-off-by: Jesper Juhl<jj@chaosbits.net>

WBR, Sergei
