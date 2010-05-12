Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab0ELPY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:24:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53866 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab0ELPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:24:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Kg4XCNgAfHWgrZvyki2b8wdbUAAYONzaXTYmXkNHltqsLp7u0OdN5FgJdsZaJeRftP
         G/zlUsGTao+BxzIgTtEu6l7bhBqUWooaG00NQpu6e10EPVm+Kr5ImVSSyKw6zOS9JW9D
         wVbivkCybYoTeBdKeNOhQEHztF8k3LFopoKHE=
Date: Wed, 12 May 2010 17:24:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, acme@infradead.org,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Subject: Re: [PATCH] perf: change event inheritance logic in stat and record
Message-ID: <20100512152447.GF5405@nowhere>
References: <4bea9d2f.d60ce30a.0b5b.08e1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bea9d2f.d60ce30a.0b5b.08e1@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 10:40:01AM +0200, Stephane Eranian wrote:
>   By default, event inheritance across fork and pthread_create was
>   on but the -i option of stat and record, which enabled inheritance,
>   led to believe it was off by default.
> 
>   This patch fixes this logic by inverting the meaning of the -i option.
>   By default inheritance is on whether you attach to a process (-p), a
>   thread (-t) or start a process. If you pass -i, then you turn off
>   inheritance. Turning off inheritance if you don't need it, helps
>   limit perf resource usage as well.
> 
>   The patch also fixes perf stat -t xxxx and perf record -t xxxx
>   which did not start the counters.
> 
>   Signed-off-by: Stephane Eranian <eranian@google.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

