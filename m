Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2LKNDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 08:03:18 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59660 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2LKNDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 08:03:17 -0500
Message-ID: <1355230993.19818.2.camel@hornet>
Subject: Re: [PATCH] mfd: vexpress-config: Export __vexpress_config_func_get
 and vexpress_config_func_put
From: Pawel Moll <pawel.moll@arm.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 11 Dec 2012 13:03:13 +0000
In-Reply-To: <1355214199.7387.3.camel@phoenix>
References: <1355214199.7387.3.camel@phoenix>
X-Mailer: Evolution 3.6.0-0ubuntu3
Mime-Version: 1.0
X-OriginalArrivalTime: 11 Dec 2012 13:03:14.0168 (UTC) FILETIME=[E1343780:01CDD79F]
X-MC-Unique: 112121113031502601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-11 at 08:23 +0000, Axel Lin wrote:
> This fixes below build error:
> 
>   Building modules, stage 2.
>   MODPOST 17 modules
> ERROR: "__vexpress_config_func_get" [drivers/regulator/vexpress.ko] undefined!
> ERROR: "vexpress_config_func_put" [drivers/regulator/vexpress.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks, I'll get this queued with other vexpress fixes.

Paweł


