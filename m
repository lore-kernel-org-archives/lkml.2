Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0DVBCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 21:02:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43498 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0DVBCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 21:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l82R+rDE9n8WtYWlJs7tsftF0Q0G6+17+YJiz9Bj9EVSpjEqg6Ht0DDCs9Tn4ePTYO
         eU2UhoJ87ubpyvcR9pDd7RqSttZYcV6RmPksbBBZ4V7Uavj1PT6g1pVEHYul0g4zktzN
         kyJm8k5UJam9b+AU/fRBnJ94TcJFZnw5PhtKg=
Date: Thu, 22 Apr 2010 03:02:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix initialization bug in
	parse_single_tracepoint_event()
Message-ID: <20100422010232.GA11936@nowhere>
References: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 06:06:01PM +0200, Stephane Eranian wrote:
> 
>   The parse_single_tracepoint_event() was setting some attributes
>   before it validated the event was indeed a tracepoint event. This
>   caused problems with other initialization routines like in the
>   builtin-top.c module whereby sample_period is not set if not 0.
> 
>   Signed-off-by: Stephane Eranian <eranian@google.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

