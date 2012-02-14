Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314Ab2BNRdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:33:51 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:39557 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab2BNRdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:33:50 -0500
Message-ID: <4F3A9AFB.7040007@hp.com>
Date: Tue, 14 Feb 2012 11:33:47 -0600
From: Mike Miller <mike.miller@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Tomas Henzl <thenzl@redhat.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: Re: [PATCH] cciss: add some older controllers to the kdump blacklist
References: <4F3A95E9.9@redhat.com>
In-Reply-To: <4F3A95E9.9@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 11:12 AM, Tomas Henzl wrote:
> Some other older controllers also do have problems to perform a kdump.
> Adding controllers to this list means that the driver will signal
> this non-ability via a resettable flag correctly.
> The unsupported list was created after a consultation with HP.
>
> Signed-off-by: Tomas Henzl<thenzl@redhat.com>

Acked-by: Mike Miller <mike.miller@hp.com>

>
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 2047978..e394f2c 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -585,6 +585,12 @@ static u32 unresettable_controller[] = {
>   	0x40800E11, /* Smart Array 5i */
>   	0x409C0E11, /* Smart Array 6400 */
>   	0x409D0E11, /* Smart Array 6400 EM */
> +	0x40700E11, /* Smart Array 5300 */
> +	0x40820E11, /* Smart Array 532 */
> +	0x40830E11, /* Smart Array 5312 */
> +	0x409A0E11, /* Smart Array 641 */
> +	0x409B0E11, /* Smart Array 642 */
> +	0x40910E11, /* Smart Array 6i */
>   };
>
>   /* List of controllers which cannot even be soft reset */
> @@ -592,6 +598,12 @@ static u32 soft_unresettable_controller[] = {
>   	0x40800E11, /* Smart Array 5i */
>   	0x409C0E11, /* Smart Array 6400 */
>   	0x409D0E11, /* Smart Array 6400 EM */
> +	0x40700E11, /* Smart Array 5300 */
> +	0x40820E11, /* Smart Array 532 */
> +	0x40830E11, /* Smart Array 5312 */
> +	0x409A0E11, /* Smart Array 641 */
> +	0x409B0E11, /* Smart Array 642 */
> +	0x40910E11, /* Smart Array 6i */
>   };
>
>   static int ctlr_is_hard_resettable(u32 board_id)
>
>

