Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1FROHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 10:07:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63038 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab1FROHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 10:07:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dIFQKvuEUDqsT0Z+7xSO4fSstc0xReK5l5Q+oYrf7FC7W+A6UeQAi/8CMfWBWDZ4Z7
         fJncIgQAXhu8vJlIqIrrdusk6dLLp/rkJe44f/x+OoDfLo1zb6Ycd8GwuD/4/4IO+vB4
         hedZhFMClKzxkGbany+PqkHcFjNFFs5DiUiW8=
Message-ID: <4DFCAFA6.7030600@gmail.com>
Date: Sat, 18 Jun 2011 16:01:10 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
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

Andrew,

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

can you give me a feedback about this patch series? Can you add it into 
your tree?

Marco
