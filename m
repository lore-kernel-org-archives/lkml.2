Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab3AIKZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:25:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895Ab3AIKZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:25:33 -0500
Date: Wed, 9 Jan 2013 11:25:15 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Frank Eigler <fche@redhat.com>, Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes: alloc utask/xol_area cleanups and minor fix
Message-ID: <20130109102515.GB21781@bandura.brq.redhat.com>
References: <20121231175150.GA32066@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121231175150.GA32066@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 06:51:50PM +0100, Oleg Nesterov wrote:
> Hello.
> 
> This series fixes the minor bug and cleanups the usage of add_utask()
> and xol_alloc_area(). Plus it cleanups the initializaion of ->utask
> in handle_swbp() paths.
> 
> Anton, this conflicts with your uretprobe patches, but I think we
> should do this to avoid the code duplication. IOW, I consider this
> series as a minor preparations for uretprobes as well.
> 
> Oleg.
> 
>  kernel/events/uprobes.c |  150 +++++++++++++++++++++--------------------------
>  1 files changed, 68 insertions(+), 82 deletions(-)
>

I haven't found anything other than small style problems, I've pointed
to in other mails to this thread.

And this patchset doesn't brake anything on my machine. :)

Acked-by: Anton Arapov <anton@redhat.com>

Anton.
