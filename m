Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab2IZR1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:27:05 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:53384 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757694Ab2IZR1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:27:02 -0400
Message-ID: <50633AE1.6020600@xenotime.net>
Date: Wed, 26 Sep 2012 10:26:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-media <linux-media@vger.kernel.org>,
        linux-next@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: mmotm 2012-09-25-17-06 uploaded (media/tuners/fc2580)
References: <20120926000747.BE7B2100047@wpzn3.hot.corp.google.com>
In-Reply-To: <20120926000747.BE7B2100047@wpzn3.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 05:07 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-09-25-17-06 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/



on i386:

ERROR: "__udivdi3" [drivers/media/tuners/fc2580.ko] undefined!
ERROR: "__umoddi3" [drivers/media/tuners/fc2580.ko] undefined!


-- 
~Randy
