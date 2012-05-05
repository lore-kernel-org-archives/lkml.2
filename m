Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab2EETXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:23:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab2EETXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:23:19 -0400
Message-ID: <4FA57F52.5070808@suse.cz>
Date: Sat, 05 May 2012 21:28:18 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 0/8] kbuild: use script for final link, move definitions
 out of top-level Makefile
References: <20120505080640.GA13773@merkur.ravnborg.org>
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 5.5.2012 10:06, Sam Ravnborg napsal(a):
> Hi Michal, all.
> 
> o Move the link of vmlinux from top-level Makefile to a script.
>   This increased the readability a lot.
>   They have had a few rounds of reviews and are ready.
> 
> o Move a lot of definitions from top-level Makefile to
>   two new files located in scripts/
> 
> o Fix so we do not call CC too often when using W=...
> 
> o Fix so KCFLAGS (and friends) are added last to the
>   command lines.
> 
> Patches 1-4 are ready to be applied.
> Patches 5-8 are new and may raise a few comments.

I merged 1-4 now, I'll look at the rest later.

Michal
