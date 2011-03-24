Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933634Ab1CXSAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:00:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58107 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565Ab1CXSAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:00:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ax+OrIo/89Q1fUoXcXndA2c+F5XVyJjV4Kcr7fUjiP8HeTuVetcBQHB5LUwSLVg7q3
         RxRo0nGixD5Zrq2WG9g2gU1UhfigSxqL1884gQP8mZtq5SAoJ9KxU5LufJ/wt9ivP6lE
         7y988xObVt59EarcJRKD/WJf2d5wIumZXy5e8=
Date: Thu, 24 Mar 2011 18:51:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: torvalds@osdl.org, Alexander van Heukelum <heukelum@fastmail.fm>,
        linux-am33-list@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        uclinux-dist-devel@blackfin.uclinux.org, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Subject: Re: [Uclinux-dist-devel] [RFC PATCH] percpu: always align percpu
 output section to PAGE_SIZE
Message-ID: <20110324175148.GA1409@htj.dyndns.org>
References: <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
 <12101.1288088542@redhat.com>
 <4CC6C62F.1000804@kernel.org>
 <4CC6C941.2080003@kernel.org>
 <4CC6CD4D.3010501@kernel.org>
 <4CC6E05A.8040508@kernel.org>
 <AANLkTi=WWCPJeQ8DVv1j7GF0J61DiUupiOEuxDCW8_Xd@mail.gmail.com>
 <20110324082523.GA12038@htj.dyndns.org>
 <20110324085112.GB12038@htj.dyndns.org>
 <AANLkTi=ZRowUtmSR+kLLphnRtyg1uqnFZ5s+_db6P54F@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=ZRowUtmSR+kLLphnRtyg1uqnFZ5s+_db6P54F@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:46:53AM -0400, Mike Frysinger wrote:
> Linus has already pulled it

Thanks.  Patch queued for 2.6.40.

-- 
tejun
