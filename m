Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1HSBOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 21:14:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47008 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab1HSBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 21:14:36 -0400
Date: Fri, 19 Aug 2011 10:14:32 +0900
From: Simon Horman <horms@verge.net.au>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: vgoyal@redhat.com, ebiederm@xmission.com, mahesh@linux.vnet.ibm.com,
        hbabu@us.ibm.com, oomichi@mxs.nes.nec.co.jp, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 0/3] kdump: Add external kdump entry point for s390
 stand-alone dump tools
Message-ID: <20110819011431.GB20747@verge.net.au>
References: <20110729123944.562622201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729123944.562622201@linux.vnet.ibm.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 02:39:44PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> I finished the patches that add the stand-alone dump tools support on
> top of the recently sent v2 patch series. The following three patches
> implement the program check idea that we have discussed recently:
> 
> [1] kdump: Add new machine_kexec_finish() architecture callback
> [2] s390: Add external kdump entry point for s390 stand-alone dump tools
> [3] kexec-tools: Emit program check on s390 for checksum failure

Hi Michael,

in general I am fine with these patches and happy to merge them
although I am a little unclear about the status of the kernel side of
things. Please let me know if you would like me to merge the kexec-tools
patches now or wait a bit (for an updated version?).

Also, if you could give me any pointers on how to obtain an s390
cross-compiling environment for x86_64 I would be most grateful.
