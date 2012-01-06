Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2AFRuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 12:50:01 -0500
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:50867 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758868Ab2AFRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 12:49:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1RGDWOitrKp31RuWLCV3ifUa=CKvZ2qZaRQJMcxdU6_eubww@mail.gmail.com>
References: <1325714596-4655-1-git-send-email-cascardo@linux.vnet.ibm.com> <CAL1RGDWOitrKp31RuWLCV3ifUa=CKvZ2qZaRQJMcxdU6_eubww@mail.gmail.com>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 6 Jan 2012 09:49:36 -0800
Message-ID: <CAL1RGDVEqr9XzzcpG6wK49e209JtrhXGayFa5Qnz_NziLinR-g@mail.gmail.com>
Subject: Re: [PATCH] rds_rdma: don't assume infiniband device is PCI
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: venkat.x.venkatsubra@oracle.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dledford@redhat.com, Jes.Sorensen@redhat.com, rds-devel@oss.oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 9:47 AM, Roland Dreier <roland@purestorage.com> wrote:
> Looks great to me:

And BTW if Oracle has some non-published work they should probably just
rebase it on top of this fix.  We should merge this rather than shipping a
kernel with an obvious know crash like this.

 - R.
