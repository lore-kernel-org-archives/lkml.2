Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1AGUdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:33:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49074 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab1AGUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:33:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fVkfM0X+sWiTii/N5T6q5+Nj2Qa5uj4YncQ19L2VcMF9JeD/p0//spQm3cM06BzAjb
         ms143THJfkyakWboeQf8m5KRnD1AEpZ44P504BNFSdT95P3EidJ208w7uX/4tU7gIzI5
         X0ijFTE+umDwwZ/uM9qwTX1LgsLs++izPFV/E=
Date: Fri, 7 Jan 2011 15:33:04 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: unify "numa=" command line option handling
Message-ID: <20110107203304.GC7355@mtj.dyndns.org>
References: <4D2603BF020000780002ACA7@vpn.id2.novell.com>
 <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101061235010.30820@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 06, 2011 at 12:36:41PM -0800, David Rientjes wrote:
> I like the idea in general, but I think it may collide with Tejun's NUMA 
> unification patchset for x86, which I assume will another revision once 
> the merge window for .38 closes?  Or maybe he'd like to merge your patch 
> with his series and push it as one?

Peter, what's the status of the patchset?  Is there something which is
holding it from being merged into x86/numa?  Are you simply waiting
for the rc1 window to close?

Thanks.

-- 
tejun
