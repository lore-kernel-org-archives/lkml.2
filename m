Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1AGUrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:47:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:2161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab1AGUrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:47:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hRKqhFyQu/myFqDZnCC1NkFoMVL6NTOc8NlqvGpJMh8g3Ejqjwss2qDkwJIf4XDslk
         flmVFQeetpheNganY0qQ==
Date: Fri, 7 Jan 2011 12:46:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
In-Reply-To: <20110107204332.GE7355@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101071245420.31653@chino.kir.corp.google.com>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com> <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com> <20110107203304.GC7355@mtj.dyndns.org> <alpine.DEB.2.00.1101071234590.31653@chino.kir.corp.google.com>
 <20110107204332.GE7355@mtj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Tejun Heo wrote:

> > I don't think it applies cleanly anymore since d906f0eb was merged, but I 
> > agree with Jan that this new feature should probably be merged for .38.
> 
> Okay, the series is already too late for this merge window at this
> point anyway.  I'm not too happy how the merge process is progressing
> but, well, it seems there needs to be another refresh.  Anyways,
> please let me know when the series needs to be refreshed.
> 

It would probably be best after -rc1 and then be on track for .39.  I know 
the unification is much desired from several different parties, I've 
referred a few different emails in the past couple months to your patchset 
and potential collisions :)
