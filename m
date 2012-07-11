Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2GKFwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:52:07 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:49226 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753384Ab2GKFwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:52:05 -0400
Message-ID: <4FFD1458.6000404@xenotime.net>
Date: Tue, 10 Jul 2012 22:51:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: linux-next: Tree for July 10 (iio)
References: <20120710174320.3b7dd806e20ee74ca1b1685f@canb.auug.org.au>
In-Reply-To: <20120710174320.3b7dd806e20ee74ca1b1685f@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 12:43 AM, Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20120709:
> 



on x86_64:

drivers/iio/dac/ad5064.c: In function 'ad5064_i2c_write':
drivers/iio/dac/ad5064.c:132:2: error: implicit declaration of function 'i2c_master_send'




-- 

~Randy
