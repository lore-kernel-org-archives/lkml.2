Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0DNGqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:46:52 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:50063 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab0DNGqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x7APW7UDfDrd42tRHR5Gqs+w093UAcOshe6pgeEeaPmERtTubifJ5Oxk7EuMc6NqN9
         4tpQw8gNERpYaL7skPeTwbeTjsBIvr6o2mM15aix++NMQB11xfcUn/zJLBHNSoDLJ0Lf
         sx+uTJr/NTn9c4dPYQtcKLR9FJxIg8yywFqY0=
Message-ID: <4BC5637C.4020606@gmail.com>
Date: Wed, 14 Apr 2010 08:41:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-6.2 Thunderbird/3.1b1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree with the limits tree
References: <20100414135905.47494958.sfr@canb.auug.org.au>
In-Reply-To: <20100414135905.47494958.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2010 05:59 AM, Stephen Rothwell wrote:
> Today's linux-next merge of the tip tree got a conflict in
> kernel/posix-cpu-timers.c between commit
> 0c1b5ce8de67c36bbf67db38240a91f358133bdd ("core: add task_struct to
> update_rlimit_cpu") from the limits tree and commit
> f55db609042faecd5e518ce372b87f846659b32e ("cpu-timers: Simplify
> RLIMIT_CPU handling") from the tip tree.
> 
> I did the obvious fixup (see below) but it is probably not completely
> correct.   Jiri, did I see Linus ask for major revisions of the writable
> limits work?

Hi. Yes, but as I didn't understand the way he described and didn't get
reply to what I asked, please drop the limits tree from -next
completely. If I ever get it into a usable state I'll apply you to merge
it again (or ask akpm again).

thanks,
-- 
js
