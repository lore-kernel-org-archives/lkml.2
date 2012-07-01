Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2GAPaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 11:30:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25996 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GAPaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 11:30:07 -0400
Date: Sun, 1 Jul 2012 18:29:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>, Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging/comedi/drivers: free allocated priv and
 release resources if comedi_alloc_subdevices
Message-ID: <20120701152943.GA4462@mwanda>
References: <1341149920-12754-1-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341149920-12754-1-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 07:08:40PM +0530, Devendra Naga wrote:
> as comedi_alloc_subdevices may fail, we leak out the memory allocated by alloc_private,
> and also the I/O regions we requested.
> 
> free out the private data pointer of the driver, and release the I/O regions.
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---

Please drop this.  Devendra sent a v2 of this.

Devendra, please reply to the thread when you want a patch to be
dropped.  Don't make other people (me) clean up for you.

regards,
dan carpenter

