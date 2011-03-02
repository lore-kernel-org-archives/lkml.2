Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1CBObk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:31:40 -0500
Received: from smtp-out.google.com ([74.125.121.67]:49188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab1CBObi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:31:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lKsfwI8nsyLP8hnkFsUtMA51214uIqdBAemWLcNV0Fn9ZWSueesauxVmIp6VvQw46E
         qIgsnhZWJ7+1kU1E90NA==
Date: Wed, 2 Mar 2011 06:31:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED x86/mm] x86-64, NUMA: Better explain numa_distance
 handling
In-Reply-To: <20110302104259.GD3319@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103020631080.31626@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <alpine.DEB.2.00.1103010844430.19743@chino.kir.corp.google.com> <20110302100400.GK19669@htj.dyndns.org>
 <20110302102530.GB3319@htj.dyndns.org> <20110302103940.GC3319@htj.dyndns.org> <20110302104259.GD3319@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Tejun Heo wrote:

> From 615e1632e55b6b8fb52da00c5e8540ef159f759b Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Wed, 2 Mar 2011 11:32:47 +0100
> 
> Handling of out-of-bounds distances and allocation failure can use
> better documentation.  Add it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
