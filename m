Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718Ab1AGUgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:36:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60122 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1AGUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:36:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ctO0ijNPD8TU1KRp9yTY7WiZEL/ZE6J+L2BghtQOs9BnRl8q3DmYfgq7ksqpQK1TYW
         +N2P3XMJk6o6UxoFdnLQ==
Date: Fri, 7 Jan 2011 12:36:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
In-Reply-To: <20110107203304.GC7355@mtj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1101071234590.31653@chino.kir.corp.google.com>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com> <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com> <20110107203304.GC7355@mtj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Tejun Heo wrote:

> > I like the idea in general, but I think it may collide with Tejun's NUMA 
> > unification patchset for x86, which I assume will another revision once 
> > the merge window for .38 closes?  Or maybe he'd like to merge your patch 
> > with his series and push it as one?
> 
> Peter, what's the status of the patchset?  Is there something which is
> holding it from being merged into x86/numa?  Are you simply waiting
> for the rc1 window to close?
> 

I don't think it applies cleanly anymore since d906f0eb was merged, but I 
agree with Jan that this new feature should probably be merged for .38.
