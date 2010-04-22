Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0DVW4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 18:56:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55261 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0DVW4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 18:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wVk6iC1bSthFhwbCliMOJlwIZVNDjGLNQF2Z2W1SIhsL9+WlT8JTMl4nI3gcXFFujY
         U/iDWRaDuyxVwupJFLYf20Ws9eNTH4xDZUzuqcLZPD7gSzRDqyTtrVqO00Nlg4L8hiF/
         IZUzKwSYnQYMYjHIL7tiMwANH1VrAlKnvD4x4=
Date: Fri, 23 Apr 2010 00:56:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, robert.richter@amd.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: fix initialization bug in
	parse_single_tracepoint_event()
Message-ID: <20100422225644.GE5600@nowhere>
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


In fact I'm queueing it.

Thanks.

