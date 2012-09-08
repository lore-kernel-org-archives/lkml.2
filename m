Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab2IHAuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 20:50:39 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:60012 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751890Ab2IHAug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 20:50:36 -0400
Message-ID: <504A9644.4070303@xenotime.net>
Date: Fri, 07 Sep 2012 17:50:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, linux-next@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>
Subject: Re: mmotm 2012-09-06-16-46 uploaded (drivers/misc/lis3lv02d/lis3lv02d_spi.c)
References: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
In-Reply-To: <20120906234735.1B54B20004E@hpza10.eem.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 04:47 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-09-06-16-46 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 



on x86_64:

CONFIG_OF and CONFIG_DTC are not enabled.


drivers/misc/lis3lv02d/lis3lv02d_spi.c:137:3: error: implicit declaration of function 'of_match_ptr'
drivers/misc/lis3lv02d/lis3lv02d_spi.c:137:3: error: initializer element is not constant
drivers/misc/lis3lv02d/lis3lv02d_spi.c:137:3: error: (near initialization for 'lis302dl_spi_driver.driver.of_match_table')


-- 
~Randy
