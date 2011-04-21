Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1DUTpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:45:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:32285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1DUTpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:45:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PncVu+bjH11NuOeAGcF2Y7nUeOH4h7HIfp57Vf5Wdsq2t7ZuhD+dYfR7wpkAKF/6qk
         WvGYxqDJrDeSnyFUe3yg==
Date: Thu, 21 Apr 2011 12:45:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Linux 2.6.39-rc4 (regression: NUMA on multi-node CPUs broken)
In-Reply-To: <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1104211243590.5829@chino.kir.corp.google.com>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com> <20110420153907.GA9000@alberich.amd.com> <alpine.DEB.2.00.1104201722540.15906@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, David Rientjes wrote:

> I'm not sure what it's trying to address (yes, there is a problem with the 
> binding for CONFIG_NUMA_EMU && CONFIG_DEBUG_PER_CPU_MAPS, but not 
> otherwise).
> 

Andreas, the revert (37f8527dbfd0) and the new NUMA emulation fix 
(7a6c6547825a) have been merged into the latest -git, please let us know 
if there are any other issues that you notice.  Thanks!
