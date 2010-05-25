Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab0EYHax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:30:53 -0400
Received: from www.wytron.com.tw ([211.75.82.101]:56993 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab0EYHav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:30:51 -0400
X-Greylist: delayed 2427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2010 03:30:51 EDT
Message-ID: <4BFB7378.6070900@wytron.com.tw>
Date: Tue, 25 May 2010 14:51:36 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Thunderbird 2.0.0.24 (X11/20100318)
MIME-Version: 1.0
To: nios2-dev@sopc.et.ntust.edu.tw
CC: netdev@vger.kernel.org, thierry.reding@avionic-design.de,
       linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>
Subject: Re: [Nios2-dev] [PATCH] ethoc: fix null dereference in ethoc_probe
References: <20100522155455.GE22515@bicker>	<1274669042-1901-1-git-send-email-thomas@wytron.com.tw> <4BFB6B4B.3020107@zhaw.ch>
In-Reply-To: <4BFB6B4B.3020107@zhaw.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.20
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Klauser wrote:
>> @@ -944,6 +946,7 @@ static int ethoc_probe(struct platform_device *pdev)
>>  	priv = netdev_priv(netdev);
>>  	priv->netdev = netdev;
>>  	priv->dma_alloc = 0;
>> +	priv->io_region_size = mmio->end - mmio->start + 1;
> 
> Better use the resource_size inline here.

Hi Tobias,

I just see your patch of resource_size from the git log. Sorry, I missed 
this one. I will send update on this. Thank you.

Cheers,
Thomas
