Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab0GNWcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:32:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13127 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0GNWcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:32:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47349221"
From: David Brown <davidb@codeaurora.org>
To: Kulikov Vasiliy <segooon@gmail.com>
Subject: Re: [PATCH 09/11] staging: msm: formatting of pointers in printk()
Date: Wed, 14 Jul 2010 15:32:13 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.1; KDE/4.4.5; x86_64; ; )
Cc: kernel-janitors@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Alexander Kurz <linux@kbdbabel.org>, Jiri Kosina <jkosina@suse.cz>,
        Javier Martinez Canillas <martinez.javier@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1279130717-15755-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1279130717-15755-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007141532.14072.davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 July 2010 11:05:17 Kulikov Vasiliy wrote:

> Use %p instead of %08x in printk().
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    2 +-

Did you mean to have an 'msm:' in the subject?  This driver isn't part
of the msm subsystem?

Thanks,
David Brown

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
