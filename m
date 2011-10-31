Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1JaJsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:48:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48657 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932359Ab1JaJsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <1320028441.2690.3.camel@phoenix>
References: <1320028441.2690.3.camel@phoenix>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 31 Oct 2011 17:48:14 +0800
Message-ID: <CAMPhdO9+40_E=7LaoMTU6BfG8P6LKP8021tMUu+kZNkNnkez_A@mail.gmail.com>
Subject: Re: [PATCH] mfd: Add missed free_irq in da903x_remove
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 10:34 AM, Axel Lin <axel.lin@gmail.com> wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/mfd/da903x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
> index 1b79c37..62ce685 100644
> --- a/drivers/mfd/da903x.c
> +++ b/drivers/mfd/da903x.c
> @@ -549,6 +549,7 @@ static int __devexit da903x_remove(struct i2c_client *client)
>        struct da903x_chip *chip = i2c_get_clientdata(client);
>
>        da903x_remove_subdevs(chip);
> +       free_irq(client->irq, chip);
>        kfree(chip);
>        return 0;
>  }
> --
> 1.7.5.4
>
>
>
>
