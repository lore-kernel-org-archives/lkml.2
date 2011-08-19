Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1HSNhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 09:37:17 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:47108 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1HSNg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 09:36:56 -0400
Subject: Re: [patch 0/3] kdump: Add external kdump entry point for s390
 stand-alone dump tools
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Simon Horman <horms@verge.net.au>, oomichi@mxs.nes.nec.co.jp,
        linux-s390@vger.kernel.org, mahesh@linux.vnet.ibm.com,
        heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org,
        hbabu@us.ibm.com, ebiederm@xmission.com, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org
In-Reply-To: <20110819132019.GA18656@redhat.com>
References: <20110729123944.562622201@linux.vnet.ibm.com>
	 <20110819011431.GB20747@verge.net.au> <1313758400.3858.12.camel@br98xy6r>
	 <20110819132019.GA18656@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Fri, 19 Aug 2011 15:36:38 +0200
Message-ID: <1313760998.3858.32.camel@br98xy6r>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Fri, 2011-08-19 at 09:20 -0400, Vivek Goyal wrote:
> On Fri, Aug 19, 2011 at 02:53:20PM +0200, Michael Holzheu wrote:
> 
> [...]
> > > although I am a little unclear about the status of the kernel side of
> > > things. Please let me know if you would like me to merge the kexec-tools
> > > patches now or wait a bit (for an updated version?).
> > 
> > I think that we are almost done with the discussion. I will send you my
> > current kexec-tools patches and would be glad, if you could integrate
> > them now.
> 
> I guess kexec-tools integration will make more sense once kernel patches
> show up atleast in one maintainer's subtree.

The s390 kexec-tools kdump code will inactive as long a kernel shows
"Crash kernel" in /proc/iomem. So IMHO there is little risk to integrate
the code.

> Also in kernel patches, atleast we need to resolve the issue of arch
> specific kmap(), kunmap() calls so that we don't have to make
> kimage_load_crash_segment() arch specific.

As I told in my last mail we will do this later. So I think there are
currently no more open issues, correct?

Michael


