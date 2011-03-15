Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1COTyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 15:54:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49012 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab1COTyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 15:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=emiGRvs3JTILQbUo1X/nfpSjRGOOPZTHPfgz5WhzXDpmxdXGs5WQb4nQKn2szgCLX0
         /mA2zt8PACd/b4ars4oQ==
Date: Tue, 15 Mar 2011 12:54:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>,
        Frantisek Hrbata <fhrbata@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 for 2.6.38] oom: oom_kill_process: don't set TIF_MEMDIE
 if !p->mm
In-Reply-To: <20110315185316.GA21640@redhat.com>
Message-ID: <alpine.DEB.2.00.1103151252000.558@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1103081549530.27910@chino.kir.corp.google.com> <20110309151946.dea51cde.akpm@linux-foundation.org> <alpine.DEB.2.00.1103111142260.30699@chino.kir.corp.google.com> <20110312123413.GA18351@redhat.com> <20110312134341.GA27275@redhat.com>
 <AANLkTinHGSb2_jfkwx=Wjv96phzPCjBROfCTFCKi4Wey@mail.gmail.com> <20110313212726.GA24530@redhat.com> <20110314190419.GA21845@redhat.com> <20110314190446.GB21845@redhat.com> <alpine.DEB.2.00.1103141314190.31514@chino.kir.corp.google.com>
 <20110315185316.GA21640@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Oleg Nesterov wrote:

> Confused. I sent the test-case. OK, may be you meant the code in -mm,
> but I meant the current code.
> 

This entire discussion, and your involvement in it, originated from these 
two patches being merged into -mm:

	oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
	oom-skip-zombies-when-iterating-tasklist.patch

So naturally I'm going to challenge your testcases with the latest -mm.  
If you wanted to suggest pushing these to 2.6.38 earlier, I don't think 
anyone would have disputed that -- I certainly wouldn't have since the 
first fixes a quite obvious panic that we've faced on a lot of our 
machines.  It's not that big of a deal, though, since Andrew has targeted 
them for -stable and they're on schedule to be pushed to 2.6.38.x
