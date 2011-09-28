Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1I1O4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:56:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:61354 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1I1O4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:56:20 -0400
Message-ID: <4E833586.5070401@windriver.com>
Date: Wed, 28 Sep 2011 10:56:06 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, Greg KH <greg@kroah.com>
Subject: Re: linux-next: manual merge of the moduleh tree with the staging
 tree
References: <20110928164419.372feaa0c5554687403a9af5@canb.auug.org.au> <20110928164824.29edfa867dfe583ff5b982e8@canb.auug.org.au>
In-Reply-To: <20110928164824.29edfa867dfe583ff5b982e8@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-09-28 02:48 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> On Wed, 28 Sep 2011 16:44:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Today's linux-next merge of the moduleh tree got a conflict in
>> drivers/staging/iio/accel/adis16201_ring.c between commit 779921683e6d
>> ("staging:iio:accel header housekeeping - remove unecessary includes")
>> from the staging tree and commit 15f310ea9641 ("staging: Add export.h for
>> THIS_MODULE/EXPORT_SYMBOL to drivers/staging users") from the moduleh
>> tree.
> 
> Also drivers/staging/iio/accel/adis16203_ring.c,
> drivers/staging/iio/accel/adis16204_ring.c,
> drivers/staging/iio/accel/adis16209_ring.c,
> drivers/staging/iio/accel/adis16240_ring.c,
> drivers/staging/iio/gyro/adis16260_ring.c and
> drivers/staging/iio/meter/ade7758_ring.c

I've moved the export.h in all of these up near the top to make
the conflict go away.

Thanks,
Paul.
