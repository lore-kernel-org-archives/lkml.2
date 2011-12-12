Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1LLSET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:04:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1LLSES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:04:18 -0500
Date: Mon, 12 Dec 2011 13:04:11 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Karel Zak <kzak@redhat.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH 1/2] Add partition resize function to BLKPG ioctl
Message-ID: <20111212180411.GE29180@redhat.com>
References: <4EE0C814.2000807@cfl.rr.com>
 <20111208151650.GB16934@nb.redhat.com>
 <4EE0D6E6.9000807@cfl.rr.com>
 <20111208155844.GA9281@redhat.com>
 <4EE0E085.8000907@cfl.rr.com>
 <20111208162847.GB9281@redhat.com>
 <4EE17815.6050806@cfl.rr.com>
 <20111212145330.GB29180@redhat.com>
 <4EE63D43.50706@cfl.rr.com>
 <1323712147.19538.2.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323712147.19538.2.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 09:49:07AM -0800, Joe Perches wrote:
> On Mon, 2011-12-12 at 12:43 -0500, Phillip Susi wrote:
> > On 12/12/2011 09:53 AM, Vivek Goyal wrote:
> []
> > > - Can we rename BLKPG_RES_PARTITION to BLKPG_RESIZE_PARTITION. It is
> > >   easier to read.
> > BLKPG_DELETE_PARTITION is also easier to read, but the existing code
> > went with DEL.  I prefer to stay consistent with the existing code and
> > also use a 3 letter name.
> 
> RES is most commonly used for RESOURCE.
> 
> If it really needs to be 3 letters, and I don't think
> it does, perhaps BLKPG_RSZ_PARTITION

Agreed. RES does not occur to me as resize but resources. ADD and DEL
are very clear. 

Thanks
Vivek
