Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1BUVzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 16:55:40 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53292 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1BUVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 16:55:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mbI/5P/t9PULPruVBe6GzQdfodjMBx1BC/2uV28noaObpJG83hp+fotgnf4Dkyee1n
         RJQkdm4TWicxrJ0krYhvCh7JMKN4j6bDDeAEDF1rs3aAJVvdECh09lmNA1ZAUNvs/DWK
         fhEBwZvPKmJ2T+aODXaD9aeHL5c53X5wSDtH0=
Date: Mon, 21 Feb 2011 22:55:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/4] perf events: Add realtime clock event and timehist
 option -v2
Message-ID: <20110221215533.GD3583@nowhere>
References: <1298322150-15505-1-git-send-email-daahern@cisco.com>
 <20110221213740.GC3583@nowhere>
 <4D62DC21.4070407@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D62DC21.4070407@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 02:41:53PM -0700, David Ahern wrote:
> 
> 
> On 02/21/11 14:37, Frederic Weisbecker wrote:
> 
> > The goal is actually to extend perf script to handle more than just raw data.
> > So that it can handle the rest of what we can find in an event: time, ip, stacktraces...
> > 
> > You've added 200 lines in perf report to add the dump support. It wouldn't
> > require more to extend perf script to do that. And the result is going to be
> > much more powerful.
> > 
> > Look at struct scripting_ops::process_event().
> 
> I actually have a draft of perf-script - essentially duplicating sample
> processing done in perf-report. When it got to the point of having to
> add a lot of code -- other features essentially -- just to get it to the
> point of being ready for this feature I stopped.


I don't understand why it's harder to extend print_event() rather than
perf report.
