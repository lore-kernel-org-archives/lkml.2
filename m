Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1GZJdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:33:10 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:48706 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab1GZJdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:33:01 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110725180714.GC11009@redhat.com>
References: <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r> <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r> <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r> <20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r> <20110718152532.GF31986@redhat.com>
	 <1311348392.5772.56.camel@br98xy6r>  <20110725180714.GC11009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 26 Jul 2011 11:32:36 +0200
Message-ID: <1311672756.4146.1.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 14:07 -0400, Vivek Goyal wrote:
> On Fri, Jul 22, 2011 at 05:26:32PM +0200, Michael Holzheu wrote:
> > Hello Vivek,
> > 
> > Still thinking how we best get elfcorehdr size...
> > 
> > On Mon, 2011-07-18 at 11:25 -0400, Vivek Goyal wrote:
> > > On Mon, Jul 18, 2011 at 04:44:13PM +0200, Michael Holzheu wrote:
> > > You could do that but I think a more generic parameter will make more
> > > sense.
> > > 
> > > - Either something along the lines of memmap=
> > > - Or excludemem=x@y
> > > - Or modify memory map in s390 specific bootloading protocol block etc.
> > 
> > Wouldn't it be most natural to pass the length along with the address of
> > the ELF core header? What about extending the kernel elfcorehdr kernel
> > parameter and adding optional size:
> > 
> > elfcorehdr=<addr>[KMG],<size>[KMG]
> 
> I think it could be memap= style. elfcorehdr=X[KMG]@Y[KMG]. Though to
> support backward compatibility we will have to support old format of
> plain elfcorehdr=X too.

Ok, fine. I will add a patch for that.

Michael


