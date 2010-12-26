Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab0LZXUX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:20:23 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34768 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab0LZXUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:20:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=WVp0Es10ZafzkNxIIBbWfScwXCCkeF7pqnYpcKzRW5xp2X3ynNyPHyha2CJ0Eg99i+
         FbyNHZPCeBWNPuw9KASvV2nq16Jn3nSuMw1cdtWtZvGN1p8+oP9lbm6lq8Sdzzzrkda6
         VHYHTlEi6eAwK6W15UJkxfhz3Yd8sqmPY0PiA=
From: Grant Coady <gcoady.lk@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Frank Rowand <frank.rowand@am.sony.com>, Matthew Wilcox <matthew@wil.cx>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent users from disabling tickless
Date: Mon, 27 Dec 2010 10:20:16 +1100
Organization: scattered
Message-ID: <1uifh69q88k2g1j0sbn6vk3ii72upqvms7@4ax.com>
References: <20101221233942.GL1263@parisc-linux.org> <4D1266F5.8040702@am.sony.com> <alpine.LFD.2.00.1012261708070.2945@x980>
In-Reply-To: <alpine.LFD.2.00.1012261708070.2945@x980>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Dec 2010 17:22:40 -0500 (EST), you wrote:

>> Why remove the ability to make the configuration choice?  Why not
>> just add the info about performance impact to the help text and
>> let me shoot myself in the foot (that is the unix way (tm)) if
>> I desire to?
>
>One can argue that configurability is one of the greatest
>strengths of Linux.  OTOH, one can also argue that users
>tend to get lost and hang themselves when given too
>much rope; and that the burden of support and maintenance
>of unnecessary config options squanders valuable resources.
>
>Personally, I have two bugs filed against my code that
>can be reproduced only in tickfull mode that almost
>nobody uses.  Is it a good use of my time to be
>distracted by by configurations that 0.01% use,
>or focus on issues seen by the other 99.99%?
>
>I'm in favor of deleting the config option,
>and the cmdline option with it, and I applaud
>Matthew for proposing such.

I always disable tickless since early on it crashed.  I guess I haven't 
bothered to risk that again, and, updating the kernel via 'make oldconfig' 
means I'm not often presented with the option, apart from first custom 
kernel after a new install.

There are many items in .cong need better help info, to inform on the 
consequences, how we (the users) supposed to know the 'new' way is now 
better than the old?

I'll try tickless, if only to gain back some unexpected performance loss on 
a RAID6 system I built recently, I've not done RAID benchmarking for five 
years ;)  I expect twice the throughput I'm getting based on a Linux NAS 
device I looked at recently.  

I ask for the better help text, unless you can show tickful operation is 
no longer required anywhere?  A better help explanation plus scheduled 
removal?  (I didn't view the patch to know if that's what it does).

Grant.
>
>Len Brown, Intel Open Source Technology Center
