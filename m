Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2BXLKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:10:51 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54440 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab2BXLK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:10:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of aneesh@ti.com designates 10.236.37.132 as permitted sender) smtp.mail=aneesh@ti.com
Message-ID: <4F47701C.2090305@ti.com>
Date: Fri, 24 Feb 2012 16:40:20 +0530
From: Aneesh V <aneesh@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH 4/8] misc: emif: add basic infrastructure for EMIF
 driver
References: <1328357771-31644-1-git-send-email-aneesh@ti.com> <1328357771-31644-5-git-send-email-aneesh@ti.com> <4F3D2F2F.8050406@ti.com>
In-Reply-To: <4F3D2F2F.8050406@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 February 2012 10:00 PM, Cousson, Benoit wrote:
> Hi Aneesh,
>

[...]

>> +struct emif_data {
>> +	u8				duplicate;
>> +	u8				temperature_level;
>> +	u32				irq;
>> +	spinlock_t			lock; /* lock to prevent races */
>
> Nit: That comment is useless, since you already have the kerneldoc comment before.

Now I remember why I did that. Without that comment checkpatch gives
this "check".

CHECK: spinlock_t definition without comment
#124: FILE: drivers/misc/emif.c:54:
+	spinlock_t			lock;

br,
Aneesh
