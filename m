Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2GINdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:33:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2GINdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:33:15 -0400
Date: Mon, 9 Jul 2012 15:30:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] uprobes: write_opcode() cleanups
Message-ID: <20120709133018.GA7954@redhat.com>
References: <20120624145936.GA23269@redhat.com> <20120706105425.GA31587@gmail.com> <20120706160704.GA8499@redhat.com> <20120706161303.GA8956@redhat.com> <20120709091247.GB2901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709091247.GB2901@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09, Ingo Molnar wrote:
>
> Once Srikar's ack is in then it would be nice to update the
> patches with the ack and resend #1-#4, to make sure I have all
> the intended patches and nothing more or less than that.

OK, will do.

I'll wait until Srikar reviews the new series, and then I'll
send everything acked.

Oleg.

