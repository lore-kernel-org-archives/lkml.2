Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab2HMHOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 03:14:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26698 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab2HMHON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 03:14:13 -0400
Date: Mon, 13 Aug 2012 10:13:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 1/2] drivers/mfd: Add realtek pcie card reader driver
Message-ID: <20120813071342.GC4546@mwanda>
References: <1344823586-2956-1-git-send-email-wei_wang@realsil.com.cn>
 <20120813064012.GC4559@mwanda>
 <5028A87A.4020403@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5028A87A.4020403@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:10:50PM +0800, wwang wrote:
> 于 2012年08月13日 14:40, Dan Carpenter 写道:
> > Looks like bitwise OR was intended here.
> Hi Dan:
> 
> Thank you. I will resend the patches.
> 

It's always best to hold off a day on resending, in case there are
other comments.

regards,
dan carpenter

