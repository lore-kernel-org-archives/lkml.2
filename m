Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab2JRNgz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:36:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33009 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab2JRNgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:36:53 -0400
Date: Thu, 18 Oct 2012 16:36:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: CSR: Fixed 41% of exceeding 80 characters
 problems on drv.c
Message-ID: <20121018133638.GP5685@mwanda>
References: <n>
 <1350230306-32515-1-git-send-email-antiroot@gmail.com>
 <1350230306-32515-2-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350230306-32515-2-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:58:26AM +0900, Sangho Yi wrote:
> -int buswidth = 0;			   /* 0 means use default, values 1,4 */
> -int sdio_clock = 50000;		 /* kHz */
> +int buswidth = 0;		/* 0 means use default, values 1,4 */
> +int sdio_clock = 50000;		/* kHz */

These are nonsense indenting.  :(

regards,
dan carpenter
