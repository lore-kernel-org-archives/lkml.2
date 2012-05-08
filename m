Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab2EHIE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 04:04:28 -0400
Received: from cernmx32.cern.ch ([137.138.144.178]:32750 "EHLO
	CERNMX32.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2EHIER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 04:04:17 -0400
Date: Tue, 8 May 2012 09:57:51 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 1/3] Staging: IndustryPack bus for the Linux Kernel
Message-ID: <20120508075751.GA18595@becoht-mvanga>
Mail-Followup-To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
References: <1336463005-26234-1-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336463005-26234-1-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Samuel,

> [snip]
>
> +#define to_ipack_dev(device) container_of(device, struct ipack_device, dev)
>
> [snip]
>
> +#define to_ipack_driver(drv) container_of(drv, struct ipack_driver, driver)

These don't need to be public as only your bus driver uses them. You can move this
into the .c file.

-- 
/manohar
