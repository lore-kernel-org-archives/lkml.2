Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1DTTMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 15:12:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab1DTTMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 15:12:52 -0400
Date: Wed, 20 Apr 2011 15:12:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        robert.richter@amd.com, andi@firstfloor.org, ming.m.lin@intel.com,
        eranian@google.com, ying.huang@intel.com,
        mathieu.desnoyers@efficios.com, acme@redhat.com
Subject: Re: [RFC] x86, perf: high volume of events produces a flood of
 unknown NMIs
Message-ID: <20110420191231.GB31724@redhat.com>
References: <20110420182613.GA31724@redhat.com>
 <4DAF2A57.1010804@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF2A57.1010804@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 10:47:51PM +0400, Cyrill Gorcunov wrote:
> > Or perhaps we don't care about this because in the end perf can't even
> > capture the data without spitting out a CPU Overload message.
> > 
> > Thoughts?
> > 
> 
> Hi Don, just a thought -- since pmi masks lvtpc we could read it and check if it's
> masked or no, though I fear it is quite time consuming operation in compare with
> frames :( (hmm, intel spec mentions only p4 and xeon as masking lvtpc)

Been there, tried that.  It seems to be masked a large majority of the
time, even when the NMIs don't appear to be back-to-back.

Cheers,
Don
