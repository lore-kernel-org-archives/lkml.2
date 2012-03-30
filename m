Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966370Ab2C3VdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:33:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50248 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966342Ab2C3Vcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:32:53 -0400
X-Sasl-enc: ACU/c2ODV6Xtmd56Zvu6g2zk8QIsJxHP2CEs8dL+/lHD 1333143172
Date: Fri, 30 Mar 2012 14:11:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, X86 <x86@kernel.org>,
        KVM <kvm@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-doc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Marcelo Tosatti <mtosatti@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Xen <xen-devel@lists.xensource.com>, Avi Kivity <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [Xen-devel] [PATCH RFC V5 1/6] debugfs: Add support to print u32
 array in debugfs
Message-ID: <20120330211120.GA15000@kroah.com>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
 <20120323080606.14568.31335.sendpatchset@codeblue>
 <20120330204912.GA29329@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330204912.GA29329@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 04:49:12PM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Mar 23, 2012 at 01:36:28PM +0530, Raghavendra K T wrote:
> > From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > 
> > Move the code from Xen to debugfs to make the code common
> > for other users as well.
> > 
> > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Suzuki Poulose <suzuki@in.ibm.com>
> > Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Greg,
> 
> I was thinking to stick this patch in my queue, but I need your
> OK since it touches fs/debugfs/file.c.

That's fine with me:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

