Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab3ACM0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:26:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35862 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab3ACM0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:26:51 -0500
Date: Thu, 3 Jan 2013 15:25:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, arnd@arndb.de, oakad@yahoo.com,
        gregkh@linuxfoundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, bp@alien8.de,
        devel@linuxdriverproject.org
Subject: Re: [PATCH v3 3/8] MFD:rtsx: Declare that the DMA address limitation
 is 32bit explicitly
Message-ID: <20130103122559.GF7247@mwanda>
References: <cover.1356662293.git.wei_wang@realsil.com.cn>
 <cd92be49bee917165009311d62e10a5f60a85a48.1356662293.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd92be49bee917165009311d62e10a5f60a85a48.1356662293.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 10:41:28AM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Realtek PCIe card reader only supports 32bit DMA
> 

Is this a bugfix?  If so what does the bug look like?

regards,
dan carpenter

