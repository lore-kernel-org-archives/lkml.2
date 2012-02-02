Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2BBRAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:00:12 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:46610 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754689Ab2BBRAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:00:09 -0500
Message-ID: <1328202004.18641.28.camel@joe2Laptop>
Subject: Re: [PATCH] [trivial] pm8001: Fix typo in pm8001_hwi.c
From: Joe Perches <joe@perches.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: jack_wang@usish.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Feb 2012 09:00:04 -0800
In-Reply-To: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
References: <1328191660-2037-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 23:07 +0900, Masanari Iida wrote:
> Correct typo "deviece" to "device" in
> drivers/scsi/pm8001/pm8001_hwi.c
[]
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
[]
> @@ -3532,7 +3532,7 @@ static void process_one_iomb(struct pm8001_hba_info *pm8001_ha, void *piomb)
> []
> -			pm8001_printk("unresgister the deviece\n"));
> +			pm8001_printk("unresgister the device\n"));

another typo of unregister


