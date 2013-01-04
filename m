Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab3ADKL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 05:11:26 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35357 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3ADKLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 05:11:23 -0500
MIME-Version: 1.0
In-Reply-To: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
References: <1353995926-4621-1-git-send-email-sachin.kamat@linaro.org>
Date: Fri, 4 Jan 2013 15:41:22 +0530
Message-ID: <CAK9yfHyYGO6r84XTnvxiOUtBtcwtKh9=H6nV6ELAft=x2mdAmg@mail.gmail.com>
Subject: Re: [PATCH 0/3] power: bq2415x_charger: Some cleanup
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org, anton.vorontsov@linaro.org
Cc: cbou@mail.ru, cbouatmailru@gmail.com, dwmw2@infradead.org,
        sachin.kamat@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27 November 2012 11:28, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> This series is build tested againt the linux-next tree (20121126)
>
> Sachin Kamat (3):
>   power: bq2415x_charger: Remove unneeded version.h inclusion
>   power: bq2415x_charger: Use module_i2c_driver
>   power: bq2415x_charger: Use devm_kzalloc()
>
>  drivers/power/bq2415x_charger.c |   28 +++++++---------------------
>  1 files changed, 7 insertions(+), 21 deletions(-)

Any comments on this series?


>
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
