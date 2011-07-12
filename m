Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab1GLPEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:04:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22470 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1GLPEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:04:36 -0400
Date: Tue, 12 Jul 2011 11:04:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>, Jens Axboe <jaxboe@fusionio.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, annie.li@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen-blkfront: Don't send closing  notification to backend in
 blkfront_closing()
Message-ID: <20110712150409.GB7831@dumpdata.com>
References: <4E16AE55.50500@oracle.com>
 <20110708160414.GA30120@dumpdata.com>
 <4E17A01F.8060505@oracle.com>
 <20110709131153.GA25916@dumpdata.com>
 <4E1BBFFD.7030900@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1BBFFD.7030900@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E1C627E.00DF:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> without the patch, after detach the device by xm block-detach timeout also umount hang in guest.
> with my patch, xm block-detach timeout in Dom0, umount in guest worked!

Ah, I failed to spot you did the unmount after the timeout. I tried to do the umount after
forcing the block-detach. [and testing confirms your patch working properly]

Looks good to me - with the only exception that the description needs to have 'xm block-attach'
and 'xm block-detach' - please change that and resubmit and attach

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: stable@kernel.org

and make sure to have Jens in the 'To:' header.
Thanks!


Jens,

Are you OK picking the amended patch (shortly to be posted) for 3.0-rc7?
