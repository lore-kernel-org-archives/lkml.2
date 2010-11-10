Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab0KJWTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:19:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55188 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211Ab0KJWTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:19:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q1kvvZw3yHAmni0h1DKpJoVL69kOsHdWBSTl4RoUEK7PJL1iHVYtHriiCejW901Vfe
         UuxF/SjVCVvhxmmJbFtR3t5u0Q5nask7xnaFOe3PoHb0Pjh+23l6hGLQI5051F0WWW9P
         lumBs7V62HVXbb8OeG/2zrwk6hbEOWmnQ2k2I=
Date: Wed, 10 Nov 2010 23:19:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: Tracing Requirements (was: [RFC/Requirements/Design] h/w error
	reporting)
Message-ID: <20101110221911.GA5355@nowhere>
References: <1289403019.2084.17.camel@laptop> <20101110174852.GB4001@elte.hu> <1289412329.12418.177.camel@gandalf.stny.rr.com> <1289413460.2084.27.camel@laptop> <20101110184105.GH22410@elte.hu> <1289415645.12418.180.camel@gandalf.stny.rr.com> <20101110191127.GA6190@nowhere> <20101110202316.GA32396@Krystal> <20101110213033.GA7682@nowhere> <1289426059.12418.209.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289426059.12418.209.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 04:54:19PM -0500, Steven Rostedt wrote:
> On Wed, 2010-11-10 at 22:30 +0100, Frederic Weisbecker wrote:
> > I wouldn't comment that, I'm not very experienced with the ring buffer
> 
> Yeah, I discussed this with Mathieu. There's a pretty trivial fix for
> this, but may require ABI breakage.



If you have this patch ready that fixes my ring buffer inexperience,
please send it right away. I might accomodate with the self-ABI breakage,
depending on what it is...

