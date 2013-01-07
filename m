Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3AGQLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:11:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab3AGQLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:11:50 -0500
Date: Mon, 7 Jan 2013 17:11:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] uprobes: Move alloc_page() from xol_add_vma() to
	xol_alloc_area()
Message-ID: <20130107161114.GA31669@redhat.com>
References: <20121231175150.GA32066@redhat.com> <20121231175212.GA32088@redhat.com> <20130107091609.GA24171@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107091609.GA24171@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07, Anton Arapov wrote:
>
> On Mon, Dec 31, 2012 at 06:52:12PM +0100, Oleg Nesterov wrote:
> > -		goto fail;
> > +		goto free_area;
> > +
> > +	area->page = area->page = alloc_page(GFP_HIGHUSER);
>
> fyi: didn't review this patch set yet, just caught the string above. ;)

OOPS, thanks, will fix.

Oleg.

