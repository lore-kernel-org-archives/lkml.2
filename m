Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350Ab1FHT6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:58:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:37970 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1FHT6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Et/yiz3A9swEY5MCXmWPiJTexMsYbKdUMq2zVb79DYzsKrgDiwh1xrhB48Vut0PuqA
         0CTJY+SoHe/Zgyxobu1YEG9mLRTcv0sLd8gyeaCA80f3vupenjTP+5dET4p4FKqESdag
         259I9vDXx7Wh2yyRSt/jSr5B65aT1Xx5XAH3o=
Message-ID: <4DEFD2F4.5000403@gmail.com>
Date: Wed, 08 Jun 2011 21:52:21 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        stevie.trujillo@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH 1/2 v3] ramoops: use module parameters instead of platform
 data if not available
References: <4DE0B9D8.3020405@gmail.com> <4DE10B4D.50501@gmail.com> <4DEE56AF.1040601@gmail.com>
In-Reply-To: <4DEE56AF.1040601@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/06/2011 18:49, Marco Stornelli ha scritto:
> From: Marco Stornelli<marco.stornelli@gmail.com>
>
> Use generic module parameters instead of platform data, if platform
> data are not available. This limitation has been introduced with
> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
>
> Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
> CC: Kyungmin Park<kyungmin.park@samsung.com>
> CC: Américo Wang<xiyou.wangcong@gmail.com>
> Reported-by: Stevie Trujillo<stevie.trujillo@gmail.com>
> ---

Stephen,

can you add this patch and "[PATCH 2/2 v3] ramoops: add a new line for 
each print" to the linux-next? Thanks.

Regards,

Marco
