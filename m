Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2JYBSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 21:18:04 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:55264 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758939Ab2JYBSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 21:18:02 -0400
Message-ID: <50889347.4070801@xenotime.net>
Date: Wed, 24 Oct 2012 18:17:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-next@vger.kernel.org
Subject: Re: mmotm 2012-10-24-17-15 uploaded (uml)
References: <20121025001628.1DEDE100047@wpzn3.hot.corp.google.com>
In-Reply-To: <20121025001628.1DEDE100047@wpzn3.hot.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 05:16 PM, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2012-10-24-17-15 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 


uml on x86_64 defconfig:

arch/um/drivers/chan_kern.c: In function 'tty_receive_char':
arch/um/drivers/chan_kern.c:89:42: error: 'struct tty_struct' has no member named 'raw'

-- 
~Randy
