Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2AMSTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:19:54 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:39887 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646Ab2AMSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:19:53 -0500
Date: Fri, 13 Jan 2012 16:17:06 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: Roland Dreier <roland@purestorage.com>
Cc: venkat.x.venkatsubra@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
Message-ID: <20120113181706.GA3904@oc1711230544.ibm.com>
References: <1325714596-4655-1-git-send-email-cascardo@linux.vnet.ibm.com>
 <CAL1RGDWOitrKp31RuWLCV3ifUa=CKvZ2qZaRQJMcxdU6_eubww@mail.gmail.com>
 <CAL1RGDVEqr9XzzcpG6wK49e209JtrhXGayFa5Qnz_NziLinR-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1RGDVEqr9XzzcpG6wK49e209JtrhXGayFa5Qnz_NziLinR-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011318-8936-0000-0000-0000059F3E17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 09:49:36AM -0800, Roland Dreier wrote:
> On Fri, Jan 6, 2012 at 9:47 AM, Roland Dreier <roland@purestorage.com> wrote:
> > Looks great to me:
> 
> And BTW if Oracle has some non-published work they should probably just
> rebase it on top of this fix.  We should merge this rather than shipping a
> kernel with an obvious know crash like this.
> 
>  - R.
> 

Hi, Roland.

Sorry that I didn't include you. Should I include the infiniband users
under net/ in the files that Infiniband maintainers take care of?

David,

Is this going through your tree? In patchwork, its state is "Not
Applicable".

Thanks.
Cascardo.

