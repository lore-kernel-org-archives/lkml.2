Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2FUFCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 01:02:07 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58430 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab2FUFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 01:02:05 -0400
X-AuditID: 9c930179-b7befae000006417-85-4fe2aacaba55
Message-ID: <4FE2AAD7.9060707@kernel.org>
Date: Thu, 21 Jun 2012 14:02:15 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.drivers.driver-project.devel,gmane.linux.kernel.mm.cc,gmane.linux.kernel
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-mm-cc@laptop.org, linux-kernel@vger.kernel.org,
        ngupta@vflare.org
Subject: Re: [PATCH 0/2] ZRAM Cleanup
References: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1340249565-29404-1-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/21/2012 12:32 PM, Marcos Paulo de Souza wrote:

> These two patches cleans a little the zram driver.
> 
> I hope you enjoy :)
> 
> Marcos Paulo de Souza (2):
>   staging: zram: Remove dead code
>   staging: zram: Remove useless struct zobj_header
> 
>  drivers/staging/zram/zram_drv.c |   18 +++---------------
>  drivers/staging/zram/zram_drv.h |   12 ------------
>  2 files changed, 3 insertions(+), 27 deletions(-)
> 

It was handled by [1] and on staging already.
[1] https://lkml.org/lkml/2012/6/8/116

Thanks.

-- 
Kind regards,
Minchan Kim
