Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3ACMpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:45:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44384 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3ACMp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:45:28 -0500
Date: Thu, 3 Jan 2013 15:44:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, arnd@arndb.de, oakad@yahoo.com,
        gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v3 7/8] MFD:rtsx: Fix checkpatch warning
Message-ID: <20130103124455.GH7247@mwanda>
References: <cover.1356662293.git.wei_wang@realsil.com.cn>
 <932361ec1ff3320031279bb60b3ec597c83a9638.1356662294.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <932361ec1ff3320031279bb60b3ec597c83a9638.1356662294.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 10:41:52AM +0800, wei_wang@realsil.com.cn wrote:
> -	dev_dbg(&(pcr->pci->dev), "N = %d, div = %d\n", N, div);
> +	dev_dbg(&(pcr->pci->dev), "N = %d, div = %d\n", n, div);
                                   ^
The comment could be updated as well.

regards,
dan carpenter

