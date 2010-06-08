Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab0FHVH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 17:07:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40899 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab0FHVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 17:07:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ASULK6+dEApyQBh6TDX5EIIbDFaJ3ckl7S0MICCIa7oaLb+EGoKPLaVnenpsy9xyhC
         CmCUxpFjca0pIuEKUfI+tKrbPBbf21MJpbz0OUdZ9jk62Micuv8E1V64x9KZKvDG0/V/
         D3wKPfhbD/eYDe5MF3/FNwwOx1R5EGacXin6I=
Date: Tue, 8 Jun 2010 23:07:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 2.6.35/stable] TP_STORE_SIGINFO(SEND_SIG_FORCED) == OOPS
Message-ID: <20100608210754.GB6433@nowhere>
References: <20100603213409.GA8307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603213409.GA8307@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:34:09PM +0200, Oleg Nesterov wrote:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
> IP: [<ffffffff8107bd37>] ftrace_raw_event_signal_generate+0x87/0x140
> 
> TP_STORE_SIGINFO() forgets about SEND_SIG_FORCED, fix.
> 
> We should probably export is_si_special() and change TP_STORE_SIGINFO()
> to use it.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Queued, thanks!

