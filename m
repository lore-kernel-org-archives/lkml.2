Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1AGJ6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 04:58:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:47151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab1AGJ6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 04:58:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=hUj03SNxh7M7YUEroPdEg4BqagSZKKX+JHRLYfWhWGqSWXtMwHgUY/MPq+GvMXFSag
         J6Bq9bSGujyXXjDlwqpA==
Date: Fri, 7 Jan 2011 01:58:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Beulich <JBeulich@novell.com>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
In-Reply-To: <4D26D3FD020000780002AED9@vpn.id2.novell.com>
Message-ID: <alpine.DEB.2.00.1101070156050.19087@chino.kir.corp.google.com>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com> <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com> <4D26D3FD020000780002AED9@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Jan Beulich wrote:

> However, the problem my patch addresses has been long standing
> (I noted it with our .32 based kernel, but according to my looking at
> the code it would go back to at least .27), so I'd like to ask for it to
> be merged independently (and I should probably have copied stable
> too), unless (quite unlikely) Tejun's merge is intended to also be
> applied to stable kernels.
> 

I don't think this should be targeted to -stable since it's not a bugfix; 
this is adding a feature that allows you to disable acpi parsing of the 
SRAT on i386.  Since Tejun's patchset is mature, I think the unification 
should be handled there (if not done so already).
