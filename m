Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab0IUBgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:36:05 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751649Ab0IUBgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:36:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/ST7AilGDS09aUILDgPtVl9et2ea+zvHsoEhIgnM
	aNDf5EpnToj7qG
Message-ID: <4C980BFF.7070707@gmx.de>
Date: Tue, 21 Sep 2010 03:35:59 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the viafb tree
References: <20100920131014.8393b0e2.sfr@canb.auug.org.au>
In-Reply-To: <20100920131014.8393b0e2.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Stephen Rothwell schrieb:
> Hi Florian,
> 
> After merging the viafb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/video/via/viafbdev.c: In function 'viafb_init_proc':
> drivers/video/via/viafbdev.c:1605: error: incompatible type for argument 3 of 'proc_create'
> 
> Caused by commit 84e3266c11318f2240e7de7868a14aa1119c613c ("viafb: add
> interface for output device configuration") which missed one conversion
> of "*viabf_entry" -> "viafb_entry".
> 
> I have used the version of the viafb tree from next-20100917 for today.
> 
> Also several commits in this tree have the "subject" line repeated in the
> commit message.

Should be fixed now.


Thanks,

Florian Tobias Schandinat
