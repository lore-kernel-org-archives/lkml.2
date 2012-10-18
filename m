Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2JRNfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:35:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41954 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab2JRNfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:35:06 -0400
Date: Thu, 18 Oct 2012 16:34:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: CSR: Fixed indentation problems on drv.c
 (tab mess)
Message-ID: <20121018133451.GO5685@mwanda>
References: <n>
 <1350230306-32515-1-git-send-email-antiroot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350230306-32515-1-git-send-email-antiroot@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:58:25AM +0900, Sangho Yi wrote:
> -module_param(use_5g,      int, S_IRUGO|S_IWUSR);
> -module_param(led_mask,    int, S_IRUGO|S_IWUSR);
> +module_param(use_5g,	  int, S_IRUGO|S_IWUSR);
> +module_param(led_mask,	int, S_IRUGO|S_IWUSR);

These things sort of lined up in the original code almost but now
they are done in a random way.  Why???

regards,
dan carpenter

