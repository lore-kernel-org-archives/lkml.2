Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2AYQlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:41:36 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:44792 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab2AYQlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:41:35 -0500
Date: Wed, 25 Jan 2012 11:39:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: Fwd: BUG in linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c
Message-ID: <20120125163910.GC23999@phenom.dumpdata.com>
References: <CAEmTpZHkKB29FLWqs0R=uD1zXBOJkfSstGgMM=8bA1VVXGT+wQ@mail.gmail.com>
 <CAEmTpZH+OeQO=RNBFh_+j_QCmPa8sGhV_OOqqsiKUMmjhBwESw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEmTpZH+OeQO=RNBFh_+j_QCmPa8sGhV_OOqqsiKUMmjhBwESw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F2030BA.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 04:20:26PM +0600, Марк Коренберг wrote:
> First, maintainer's addresses (Ryan Wilson <hap9@epoch.ncsc.mil>,
> Chris Bookholt <hap10@epoch.ncsc.mil>) are wrong (users unknown to
> remote mailsystem), so posting to you:

Those are the authors ones.. If you do:
konrad@phenom:~/work/linux$ scripts/get_maintainer.pl -f drivers/xen/xen-pciback/pci_stub.c
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> (supporter:XEN HYPERVISOR IN...,commit_signer:11/11=100%)
Jeremy Fitzhardinge <jeremy@goop.org> (supporter:XEN HYPERVISOR IN...,commit_signer:2/11=18%)
Jan Beulich <jbeulich@suse.com> (commit_signer:1/11=9%)
xen-devel@lists.xensource.com (open list:XEN HYPERVISOR IN...)
virtualization@lists.linux-foundation.org (open list:XEN HYPERVISOR IN...)
linux-kernel@vger.kernel.org (open list)

> 
> PCI bus format strings are wrong.
> 
> "%04x:%02x:%02x.%d"
> 
> should be used instead of
> 
> "%04x:%02x:%02x.%1x"

Oh? Would you be willing to come up with a patch with your SOB, please?

> 
> (in many places of linux+v3.2.1/drivers/xen/xen-pciback/pci_stub.c)
> 
> -- 
> Segmentation fault
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
