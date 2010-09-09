Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab0IILkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:40:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41606 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab0IILku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TeO6qW99Wk/GTliBBNwKmALHwxyeIl66Vc0SL6qUKqSl/KdRm4Pn26YpHkVchoC9p9
         D5F1b/8uawrNEu89KzGraCLK2hrrpuCRFrOdSOFiOqsiW9I1qdiGv3Cd7qtPH0taiZS2
         9kTa1kW2w5r3JWABxL8JZT3ljAAWfhzOtg6fk=
Date: Thu, 9 Sep 2010 13:40:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <hgu1972@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf events over (net) console?
Message-ID: <20100909114057.GB5267@nowhere>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com> <1284031141.402.1.camel@laptop> <20100909112940.GA5267@nowhere> <1284032142.402.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284032142.402.5.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 01:35:42PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-09-09 at 13:29 +0200, Frederic Weisbecker wrote:
> > But if we bring the splice support,
> 
> Even simply write() from the mmap() buffer isn't terribly expensive. But
> yeah, once we fix splice not to always copy that could be even better.
> 
> Splice() is on the todo list, but it needs significant user-interface
> work and I'm rather busy..


Yeah sure, that wasn't a citicism, just an idea on how that kind of
minimal userspace noise state can be achieved in the future :)

