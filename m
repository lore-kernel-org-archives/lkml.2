Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3ADFvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 00:51:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31992 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3ADFvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 00:51:07 -0500
Date: Fri, 4 Jan 2013 08:50:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "oakad@yahoo.com" <oakad@yahoo.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "bp@alien8.de" <bp@alien8.de>, "cjb@laptop.org" <cjb@laptop.org>
Subject: Re: [PATCH v3 3/8] MFD:rtsx: Declare that the DMA address
 limitationis32bit explicitly
Message-ID: <20130104055031.GQ7247@mwanda>
References: <cover.1356662293.git.wei_wang@realsil.com.cn>
 <cd92be49bee917165009311d62e10a5f60a85a48.1356662293.git.wei_wang@realsil.com.cn>
 <20130103122559.GF7247@mwanda>
 <50E6427E.1050809@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50E6427E.1050809@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 10:46:22AM +0800, wwang wrote:
> 于 2013年01月03日 20:25, Dan Carpenter 写道:
> > On Fri, Dec 28, 2012 at 10:41:28AM +0800, wei_wang@realsil.com.cn wrote:
> >> From: Wei WANG <wei_wang@realsil.com.cn>
> >>
> >> Realtek PCIe card reader only supports 32bit DMA
> >>
> > Is this a bugfix?  If so what does the bug look like?
> >
> > regards,
> > dan carpenter
> >
> Hi Dan:
> 
> No, this is not a bugfix. In default, the kernel will allocate 32bit
> address for DMA. This declaration can improve the readability.
> 

Ah ok.  Really none of the things I mentioned were stuff that
prevented the patch from being merged or couldn't be fixed in follow
on patches.

The thing is that the commit message should always say why a patch
is needed.

regards,
dan carpenter

