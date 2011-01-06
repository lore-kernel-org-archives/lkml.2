Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1AFUgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:36:50 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1AFUgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:36:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=w9AbZai5OG2xBzOhNl/Kxst3IMx/hjVPUfcIZhqCPPwIHyjySDGFokbCXuCZGyW29t
         DUMLjnYZizKSXbkcWwSQ==
Date: Thu, 6 Jan 2011 12:36:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jan Beulich <JBeulich@novell.com>
cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
In-Reply-To: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
Message-ID: <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Jan Beulich wrote:

> In order to be able to suppress the use of SRAT tables that 32-bit
> Linux can't deal with (possibly leading to a non-bootable system,
> without disabling ACPI altogether), move the "numa=" option handling
> to common code.
> 

I like the idea in general, but I think it may collide with Tejun's NUMA 
unification patchset for x86, which I assume will another revision once 
the merge window for .38 closes?  Or maybe he'd like to merge your patch 
with his series and push it as one?
