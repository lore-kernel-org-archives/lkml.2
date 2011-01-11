Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1AKVel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:34:41 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7233 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1AKVeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:34:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type:content-id;
        b=PshelH2stHamCCczLz6aKuu959ntl01psGqApEIzEtjU+kun6vupQZpXnj7ESHuCO9
         uhHw5GPh0TAkAl9FU/ag==
Date: Tue, 11 Jan 2011 13:34:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] kmemleak: Reduce verbosity when memory allocation
 fails
In-Reply-To: <1294749841.4666.49.camel@e102109-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.00.1101111332330.7551@chino.kir.corp.google.com>
References: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com> <alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com> <AANLkTik-NwSioPg96EFUDzuK=zK0kNbvUeQbt0rwQAtX@mail.gmail.com> <alpine.DEB.2.00.1101101527580.15655@chino.kir.corp.google.com>
 <1294749841.4666.49.camel@e102109-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-1944214422-1294781648=:7551"
Content-ID: <alpine.DEB.2.00.1101111334240.7551@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-1944214422-1294781648=:7551
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1101111334241.7551@chino.kir.corp.google.com>

On Tue, 11 Jan 2011, Catalin Marinas wrote:

> kmemleak: Allow kmemleak metadata allocations to fail
> 
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> This patch adds __GFP_NORETRY and __GFP_NOMEMALLOC flags to the kmemleak
> metadata allocations so that it has a smaller effect on the users of the
> kernel slab allocator. Since kmemleak allocations can now fail more
> often, this patch also reduces the verbosity by passing __GFP_NOWARN and
> not dumping the stack trace when a kmemleak allocation fails.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Ted Ts'o <tytso@mit.edu>

Acked-by: David Rientjes <rientjes@google.com>
--531368966-1944214422-1294781648=:7551--
