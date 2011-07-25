Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1GYSHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 14:07:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab1GYSHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 14:07:25 -0400
Date: Mon, 25 Jul 2011 14:07:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110725180714.GC11009@redhat.com>
References: <20110714180528.GF6672@redhat.com>
 <1310739717.10789.31.camel@br98xy6r>
 <20110715143820.GG3428@redhat.com>
 <1310744603.10789.79.camel@br98xy6r>
 <20110718123140.GB31986@redhat.com>
 <1310997641.4427.10.camel@br98xy6r>
 <20110718141943.GE31986@redhat.com>
 <1311000253.4427.23.camel@br98xy6r>
 <20110718152532.GF31986@redhat.com>
 <1311348392.5772.56.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311348392.5772.56.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 05:26:32PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> Still thinking how we best get elfcorehdr size...
> 
> On Mon, 2011-07-18 at 11:25 -0400, Vivek Goyal wrote:
> > On Mon, Jul 18, 2011 at 04:44:13PM +0200, Michael Holzheu wrote:
> > You could do that but I think a more generic parameter will make more
> > sense.
> > 
> > - Either something along the lines of memmap=
> > - Or excludemem=x@y
> > - Or modify memory map in s390 specific bootloading protocol block etc.
> 
> Wouldn't it be most natural to pass the length along with the address of
> the ELF core header? What about extending the kernel elfcorehdr kernel
> parameter and adding optional size:
> 
> elfcorehdr=<addr>[KMG],<size>[KMG]

I think it could be memap= style. elfcorehdr=X[KMG]@Y[KMG]. Though to
support backward compatibility we will have to support old format of
plain elfcorehdr=X too.

Thanks
Vivek
