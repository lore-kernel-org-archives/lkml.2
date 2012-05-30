Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2E3VXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:23:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30026 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2E3VXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:23:20 -0400
Date: Wed, 30 May 2012 17:16:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, shli@fusionio.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        xen-devel@lists.xensource.com, Shaohua Li <shli@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [Xen-devel] swap: don't do discard if no discard option added
Message-ID: <20120530211614.GA31789@phenom.dumpdata.com>
References: <CAJ75kXbC3gqQAaghKo2i1L650dw9-vrFuEwoy4defagoyR8p4Q@mail.gmail.com>
 <20120521181558.GA7829@phenom.dumpdata.com>
 <alpine.LSU.2.00.1205261113470.2033@eggly.anvils>
 <20120529144743.GG3558@phenom.dumpdata.com>
 <CAJ75kXZSqyyk0j2sNS1gq8fV_Z+Kj12mxKmpOAjKmwhDxs_9vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXZSqyyk0j2sNS1gq8fV_Z+Kj12mxKmpOAjKmwhDxs_9vQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:29:16PM +0200, William Dauchy wrote:
> Hello Konrad,
> 
> On Tue, May 29, 2012 at 4:47 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > I think I know and just narrowed down the issue this Friday.
> > William, could you please apply the patch outlined in
> > https://bugzilla.redhat.com/show_bug.cgi?id=824641
> > to your dom0 and see if that (so do not have 052b198 in your branch)
> 
> I applied the patch on dom0 and removed 052b198 from my virtual
> machine and it worked.

Great. Is it OK to attach a Tested-by tag to the patch with your name?
> 
> Regards,
> -- 
> William
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
