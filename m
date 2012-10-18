Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2JRNbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:31:32 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42180 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756007Ab2JRNbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:31:20 -0400
Date: Thu, 18 Oct 2012 16:31:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Drivers: Staging: CSR: Fixed indentation problems on
 data_tx.c
Message-ID: <20121018133106.GN5685@mwanda>
References: <n>
 <1350227813-30880-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350227813-30880-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:16:50AM +0900, Sangho Yi wrote:
> @@ -15,36 +15,37 @@
>  #include "csr_wifi_hip_unifi.h"
>  #include "unifi_priv.h"
>  
> -int
> -uf_verify_m4(unifi_priv_t *priv, const unsigned char *packet, unsigned int length)
> -{
> -    const unsigned char *p = packet;
> -    u16 keyinfo;
> +int uf_verify_m4 (unifi_priv_t *priv, const unsigned char *packet,
> +	unsigned int length) {

The original was correct.  The new code is wrong.

regards,
dan carpenter

