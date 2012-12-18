Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2LRSnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:43:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26844 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2LRSnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:43:04 -0500
Date: Tue, 18 Dec 2012 21:42:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/6] Remove incorrect usage of IS_ERR_OR_NULL on
 clk_get
Message-ID: <20121218184256.GI5032@mwanda>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 06:34:02AM +1300, Tony Prisk wrote:
> Resend to include mailing lists.
> 
> As per the kernel docs, clk_get() cannot return NULL.
> 

It returns NULL if CONFIG_HAVE_CLK is disabled.

regards,
dan carpenter

