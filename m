Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab1GKOIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:08:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab1GKOIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:08:05 -0400
Date: Mon, 11 Jul 2011 10:07:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, hbabu@us.ibm.com, mahesh@linux.vnet.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch 0/9] kdump: Patch series for s390 support
Message-ID: <20110711140754.GD30674@redhat.com>
References: <20110704170922.976299676@linux.vnet.ibm.com>
 <20110705202615.GJ24348@redhat.com>
 <1309944287.3937.39.camel@br98xy6r>
 <20110707193321.GE28850@redhat.com>
 <1310133738.3508.245.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310133738.3508.245.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 04:02:18PM +0200, Michael Holzheu wrote:
> Hello Vivek,
> 
> I attached a document where the s390 port is described in more detail.
> Perhaps this helps you to understand what want and what we are doing. If
> not - just delete it :-)
> 

Michael,

Thanks for the documentation. I have gone through it quickly and there
are some parts I am still missing.

On x86, after the kernel crash we jump to purgatory code which does the
checksum verification of all the loaded segments and if everything is
fine, it jumps to kdump kernel's entry point and second kernel boots.

On s390, looks like after purgatory, control is going to some other
piece of code (which does IPL?), and that code decides whether to
start kdump kernel or launch stand alone kernel as backup plan?

If yes, is that code whic does the IPL, also loaded in crashkernel memory
as part of kdump kernel? If not, how does kexec-tools come to know
where to jump after doing checksum on loaded kernel?

Thanks
Vivek

