Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1GVP0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:26:52 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:56814 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab1GVP0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:26:50 -0400
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, ebiederm@xmission.com,
        hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com, oomichi@mxs.nes.nec.co.jp,
        horms@verge.net.au, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20110718152532.GF31986@redhat.com>
References: <20110714091800.720da848@mschwide>
	 <20110714175532.GE6672@redhat.com> <20110714180528.GF6672@redhat.com>
	 <1310739717.10789.31.camel@br98xy6r> <20110715143820.GG3428@redhat.com>
	 <1310744603.10789.79.camel@br98xy6r> <20110718123140.GB31986@redhat.com>
	 <1310997641.4427.10.camel@br98xy6r> <20110718141943.GE31986@redhat.com>
	 <1311000253.4427.23.camel@br98xy6r>  <20110718152532.GF31986@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 22 Jul 2011 17:26:32 +0200
Message-ID: <1311348392.5772.56.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

Still thinking how we best get elfcorehdr size...

On Mon, 2011-07-18 at 11:25 -0400, Vivek Goyal wrote:
> On Mon, Jul 18, 2011 at 04:44:13PM +0200, Michael Holzheu wrote:
> You could do that but I think a more generic parameter will make more
> sense.
> 
> - Either something along the lines of memmap=
> - Or excludemem=x@y
> - Or modify memory map in s390 specific bootloading protocol block etc.

Wouldn't it be most natural to pass the length along with the address of
the ELF core header? What about extending the kernel elfcorehdr kernel
parameter and adding optional size:

elfcorehdr=<addr>[KMG],<size>[KMG]

Michael

