Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933061Ab2GENfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:35:45 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13682 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2GENfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:35:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Jul 2012 06:35:40 -0700
Message-ID: <4FF59710.60004@nvidia.com>
Date: Thu, 5 Jul 2012 19:00:56 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] gpio: tps65910: initialize of_node of gpio_chip
References: <1341414405-6401-1-git-send-email-ldewangan@nvidia.com> <CACRpkdbaNt=KX0s7vGrDzM7wKps3KFd1aF5B_S+E-LCt=XQ4DQ@mail.gmail.com>
In-Reply-To: <CACRpkdbaNt=KX0s7vGrDzM7wKps3KFd1aF5B_S+E-LCt=XQ4DQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 July 2012 07:01 PM, Linus Walleij wrote:
> On Wed, Jul 4, 2012 at 5:06 PM, Laxman Dewangan<ldewangan@nvidia.com>  wrote:
>
>> Initialize the gpio chip's of_node to the device's node
>> to work with DT based system.
>>
>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
> Applied.
>
> I will not send this to the -rc:s unless you tell me it's urgent...
> I couldn't quite tell if it was.

Having on next rc is good.



