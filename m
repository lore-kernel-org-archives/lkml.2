Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab0LKUMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:12:16 -0500
Received: from serv04.lahn.de ([213.239.197.57]:50529 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab0LKUMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:12:15 -0500
X-Greylist: delayed 1310 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Dec 2010 15:12:14 EST
Message-ID: <4D03D5F8.4010206@newton.leun.net>
Date: Sat, 11 Dec 2010 20:50:16 +0100
From: Michael Leun <vb-contact@newton.leun.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Michael Leun <lkml20101129@newton.leun.net>, hughd@google.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: kernel BUG at mm/truncate.c:475!
References: <20101130194945.58962c44@xenia.leun.net>	<alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com>	<E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu>	<20101201124528.6809c539@xenia.leun.net>	<E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>	<20101202084159.6bff7355@xenia.leun.net>	<20101202091552.4a63f717@xenia.leun.net>	<E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu>	<20101202115722.1c00afd5@xenia.leun.net>	<20101203085350.55f94057@xenia.leun.net>	<E1PPaIw-0004pW-Mk@pomaz-ex.szeredi.hu> <20101206204303.1de6277b@xenia.leun.net> <E1PRQDn-0007jZ-5S@pomaz-ex.szeredi.hu>
In-Reply-To: <E1PRQDn-0007jZ-5S@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi schrieb:
> On Mon, 6 Dec 2010, Michael Leun wrote:
>> At the moment I'm trying to create an easy to reproduce scenario.
>>

To be honest that somewhat sliddered down on my todo-list due to not
much time and kernel_cache worked around that...

> I've managed to reproduce the BUG.

...so I'm very happy you found a way to reproduce yourself.

[...]

> Attached patch attempts to do this without adding more fields to
> struct address_space.  It fixes the bug in my testing.

I'll add this patch on my work machine monday morning (happened for me
only on that quadcore, I realize now...) and turn off kernel_cache
again, of course, and let you know what happens.

Thanks.
