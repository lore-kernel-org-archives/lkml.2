Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2LCJ6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:58:35 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:52565 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2LCJ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:58:33 -0500
Message-ID: <50BC77C5.7090309@pobox.com>
Date: Mon, 03 Dec 2012 04:58:29 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_piix: re-oder code and remove prototypes
References: <201211301156.04953.b.zolnierkie@samsung.com>
In-Reply-To: <201211301156.04953.b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 05:56 AM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH] ata_piix: re-oder code and remove prototypes
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Jeff, please apply.  Thanks!
>
>   drivers/ata/ata_piix.c |  419 +++++++++++++++++++++++--------------------------
>   1 file changed, 198 insertions(+), 221 deletions(-)

applied



