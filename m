Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0CWNYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:24:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:58637 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0CWNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:24:32 -0400
Message-ID: <4BA8C105.9020308@windriver.com>
Date: Tue, 23 Mar 2010 08:24:21 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: linux-next: manual merge of the kgdb tree with the input tree
References: <20100323140946.b56c1d8b.sfr@canb.auug.org.au>
In-Reply-To: <20100323140946.b56c1d8b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Mar 2010 13:24:21.0591 (UTC) FILETIME=[260A1E70:01CACA8C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:09 PM, Stephen Rothwell wrote:
> Hi Jason,
>
> Today's linux-next merge of the kgdb tree got a conflict in
> drivers/char/keyboard.c between commit
> edc6e384f9d96e54a6d03068d3b03fa5b56b6449 ("Input: implement SysRq as a
> separate input handler") from the input tree and commit
> 4e4b600bf7160c11893bc3f4f8da8a70777b23ba ("When issuing an alt-sysrq-KEY
> sequence with the keyboard driver in the")
> from the kgdb tree.
>
> The latter changes code moved to another file by the former.  I don't
> know how to fix this up, so I have just effectively reverted the kgdb
> commit for now - suggestions welcome.
>
> BTW, the author of that kgdb commit is "Jason Wessel Subject: [PATCH]
> <jason.wessel@windriver.com>".
>
>   
I will drop mine for now.  Dmitry and I have differing implementations
to solve the same sort of problem with trapping the sysrq.  I had wanted
to test Dmitry's patch at some point soon.

I had updated kgdb-next to include the RFC patches for the keyboard and
kms code, but it is all removed again until we sort out which
implementation we will roll with.

Thanks,
Jason.
