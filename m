Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab2CZUvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:51:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab2CZUvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:51:07 -0400
Message-ID: <4F70D6BE.6000202@suse.cz>
Date: Mon, 26 Mar 2012 22:51:10 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, sboyd@codeaurora.org,
        kernel-janitors@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/api/simple_open.cocci: semantic patch
 for simple_open()
References: <1331657917-4552-1-git-send-email-Julia.Lawall@lip6.fr> <20120326204407.GC10259@sepie.suse.cz> <20120326134821.fb74a5b4.akpm@linux-foundation.org>
In-Reply-To: <20120326134821.fb74a5b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 26.3.2012 22:48, Andrew Morton napsal(a):
> On Mon, 26 Mar 2012 22:44:07 +0200
> Michal Marek <mmarek@suse.cz> wrote:
> 
>> On Tue, Mar 13, 2012 at 05:58:37PM +0100, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>>
>>> Find instances of an open-coded simple_open() and replace them
>>> with calls to simple_open().
>>>
>>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>> Reported-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>> Thanks, applied to kbuild.git#misc now.
>>
> 
> That's a bit premature, as simple_open() isn't upstream yet.

Oops, sorry. I haven't pushed the branch yet, so I will remove the patch
again.

Michal
