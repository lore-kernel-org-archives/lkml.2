Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1EUUmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 16:42:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37438 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab1EUUl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 16:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=k3wHPTlJnNinABhkMa7WTGDu2SbRF52jMXfa/E5QJ3mo+q/AZ1i4KTaVxGoL4dO4/V
         /qaF67eZ6FzsThC84cWGphtmR/h61pQxODK8LQvqZ0I0C75kqfxphwp1wbSPTzmtR3/H
         wxvGrAQuKT/bxRLqmCKuTTQnhWnMHilggnAe0=
Date: Sat, 21 May 2011 17:41:48 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jim Cromie <jim.cromie@gmail.com>, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 1/2] perf stat: add -l <N> option to redirect stderr
 elsewhere
Message-ID: <20110521204148.GB10330@ghostprotocols.net>
References: <1305968203-14240-1-git-send-email-jim.cromie@gmail.com>
 <1305968203-14240-2-git-send-email-jim.cromie@gmail.com>
 <20110521103418.GB23651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521103418.GB23651@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, May 21, 2011 at 12:34:18PM +0200, Ingo Molnar escreveu:
> 
> * Jim Cromie <jim.cromie@gmail.com> wrote:
> 
> > This perf stat option emulates valgrind's --log-fd option, allowing the
> > user to send perf results elsewhere, and leaving stderr for use by the
> > program under test.
> > 
> >   3>results perf stat -l 3 -- <cmd>
> > 
> > The perl distro's make test.valgrind target uses valgrinds --log-fd
> > option, I've adapted it to invoke perf also, and tested this patch there.
> > 
> > Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
> 
> Makes sense!
> 
> Arnaldo, if you are fine with it, do you want to pick it up - or should i? If 
> you pick it up:
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Its ok with me:

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

I will pick it this weekend, if you don't merge it till then.

- Arnaldo
