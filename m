Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536Ab1CCRIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:08:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56114 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab1CCRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lzVC/sLwdXadvUsjt2phoXSS1X4qVbRQWdvPgwHyfBdqu7EDkFmJFPh7FB78PJaApV
         S7oB0izrewHdHLq/jxxwZ4OaiV8JRqZgT/3anevJGNSeYt8oaPvaqUV5CHaRghaXEVnR
         Me3cXMdU6inLSl63xMnRAxB8jzJvojF4Q/0Xo=
Date: Thu, 3 Mar 2011 18:07:56 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 1/3] perf script: change process_event prototype
Message-ID: <20110303170750.GB1807@nowhere>
References: <1299086960-26964-1-git-send-email-daahern@cisco.com>
 <1299086960-26964-2-git-send-email-daahern@cisco.com>
 <20110303024003.GC1946@nowhere>
 <4D6FA19A.3040604@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6FA19A.3040604@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 07:11:38AM -0700, David Ahern wrote:
> 
> 
> On 03/02/2011 07:40 PM, Frederic Weisbecker wrote:
> > Seems the thread is needed by any endpoints. It would be better to resolve
> > it from process_sample_event and pass it to the process_event() handler.
> 
> tracepoints yes; S/W samples no. If you want it I'll add it.

Hmm, yeah that looks more sensible, the majority of users seem to need it.

Thanks.
