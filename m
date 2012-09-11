Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2IKJ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:58:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41366 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2IKJ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:58:43 -0400
Date: Tue, 11 Sep 2012 12:57:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 20/20] Staging: ipack/bridges/tpci200: Store the irq
 holder in slot_irq.
Message-ID: <20120911095749.GA19410@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-20-git-send-email-siglesias@igalia.com>
 <20120911085106.GS19396@mwanda>
 <1347354310.4539.87.camel@fourier.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347354310.4539.87.camel@fourier.local.igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 11:05:10AM +0200, Samuel Iglesias Gonsálvez wrote:
> On Tue, 2012-09-11 at 11:51 +0300, Dan Carpenter wrote:
> > The whole patchset looks good.
> > 
> > Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > regards,
> > dan carpenter
> 
> Taking into account that I need to resend the patches, I can add these
> suggestions.
> 

Do whatever is easiest.  Staging/ has different review standards
from mm/ and we're trying to churn through the code and clean it up
as quickly as feasible.  The review comments I had were minor style
issues, which I hope you will consider for later patches, but not
something which is worth delaying over.

regards,
dan carpenter

