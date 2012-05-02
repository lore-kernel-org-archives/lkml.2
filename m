Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2EBBBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:01:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43848 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2EBBBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:01:50 -0400
Date: Tue, 1 May 2012 18:01:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Nick Piggin <npiggin@gmail.com>
cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@gmail.com, Neil Brown <neilb@suse.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Subject: Re: [RFC] vmalloc: add warning in __vmalloc
In-Reply-To: <CAPa8GCD2m9R8YWY2FhO=LOMvCHhC6T=iFdn2YmpLxjO96_B4Ew@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205011800220.13575@chino.kir.corp.google.com>
References: <1335516144-3486-1-git-send-email-minchan@kernel.org> <alpine.DEB.2.00.1204270323000.11866@chino.kir.corp.google.com> <CAPa8GCBN6U_GRaG=GYFByNB4REcVA-yy+kKMMbrGaDKULUXW9w@mail.gmail.com> <alpine.DEB.2.00.1205011310180.7742@chino.kir.corp.google.com>
 <CAPa8GCD2m9R8YWY2FhO=LOMvCHhC6T=iFdn2YmpLxjO96_B4Ew@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2012, Nick Piggin wrote:

> Because it needs to be an ongoing thing, which is caught as soon as the
> developer writes some code, rather than continually audited for and fixed
> up after the fact. There is not a good way to enforce this at compile time.
> 
> The existing callers do need to be fixed too, of course.
> 

I'm asking that existing callers be fixed up before such a warning is 
introduced.
