Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3AIPwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 10:52:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758029Ab3AIPwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 10:52:10 -0500
Date: Wed, 9 Jan 2013 16:51:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes: Fold xol_alloc_area() into get_xol_area()
Message-ID: <20130109155131.GA27120@redhat.com>
References: <20121231175150.GA32066@redhat.com> <20121231175216.GA32091@redhat.com> <20130109101654.GA21781@bandura.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109101654.GA21781@bandura.brq.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09, Anton Arapov wrote:
>
> On Mon, Dec 31, 2012 at 06:52:16PM +0100, Oleg Nesterov wrote:
> > + * get_alloc_area - Allocate process's xol_area if necessary.
> > + * This area will be used for storing instructions for execution out of line.
> >   *
> >   * Returns the allocated area or NULL.
> >   */
>
> + * get_xol_area ....

Ah, comment, yes. Thanks, fixed.

Oleg.

