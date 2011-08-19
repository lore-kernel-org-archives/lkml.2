Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1HSMxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:53:41 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41401 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab1HSMxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:53:38 -0400
Subject: Re: [patch 0/3] kdump: Add external kdump entry point for s390
 stand-alone dump tools
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Simon Horman <horms@verge.net.au>
Cc: oomichi@mxs.nes.nec.co.jp, linux-s390@vger.kernel.org,
        mahesh@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        linux-kernel@vger.kernel.org, hbabu@us.ibm.com, ebiederm@xmission.com,
        schwidefsky@de.ibm.com, kexec@lists.infradead.org, vgoyal@redhat.com
In-Reply-To: <20110819011431.GB20747@verge.net.au>
References: <20110729123944.562622201@linux.vnet.ibm.com>
	 <20110819011431.GB20747@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 19 Aug 2011 14:53:20 +0200
Message-ID: <1313758400.3858.12.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Simon,

On Fri, 2011-08-19 at 10:14 +0900, Simon Horman wrote:
> On Fri, Jul 29, 2011 at 02:39:44PM +0200, Michael Holzheu wrote:
> > Hello Vivek,
> > 
> > I finished the patches that add the stand-alone dump tools support on
> > top of the recently sent v2 patch series. The following three patches
> > implement the program check idea that we have discussed recently:
> > 
> > [1] kdump: Add new machine_kexec_finish() architecture callback
> > [2] s390: Add external kdump entry point for s390 stand-alone dump tools
> > [3] kexec-tools: Emit program check on s390 for checksum failure
> 
> Hi Michael,
> 
> in general I am fine with these patches and happy to merge them

That's good news.

> although I am a little unclear about the status of the kernel side of
> things. Please let me know if you would like me to merge the kexec-tools
> patches now or wait a bit (for an updated version?).

I think that we are almost done with the discussion. I will send you my
current kexec-tools patches and would be glad, if you could integrate
them now.

>From Monday I will be two weeks on vacation. If there are additional
questions please contact Martin Schwidefsky and Heiko Carstens.

> Also, if you could give me any pointers on how to obtain an s390
> cross-compiling environment for x86_64 I would be most grateful.

There are debian packages for under:
http://debian.speedblue.org/ 

Michael

