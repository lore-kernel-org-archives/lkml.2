Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1GMXSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 19:18:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55954 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab1GMXSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 19:18:42 -0400
Subject: Re: [PATCH 1/6] sched: Fix (harmless) typo 'CONFG_FAIR_GROUP_SCHED'
From: Peter Zijlstra <peterz@infradead.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Jiri Kosina <jkosina@suse.cz>,
        "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1107140057240.22281@swampdragon.chaosbits.net>
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310580816-10861-2-git-send-email-schnhrr@cs.tu-berlin.de>
	 <1310590281.2586.34.camel@twins>
	 <alpine.LNX.2.00.1107140006170.5754@pobox.suse.cz>
	 <1310595172.2586.48.camel@twins>
	 <alpine.LNX.2.00.1107140029010.22281@swampdragon.chaosbits.net>
	 <1310597043.2586.60.camel@twins>
	 <alpine.LNX.2.00.1107140057240.22281@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jul 2011 01:18:24 +0200
Message-ID: <1310599104.2586.68.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-14 at 01:03 +0200, Jesper Juhl wrote:
> Do yourself a favour, if you try it, and spend a bit of time in the Setup 
> menu configuring it to the threading style you want, the headers you want 
> displayed by default, etc etc... The defaults are less than perfect if you 
> ask me, but it's quite configurable :) 

It seems to suffer the same problem mutt does, trying to sort a folder
with a shade under 600000 emails in it doesn't work (500+ seconds in
waiting and still nothing).

Evolution seems to pull it off in a few seconds, I very frequently flip
between threaded and received time sort, evo's problem is in it
consuming a silly amount of memory to do it (current res footprint of
evo is 1.3g).

I thought this was a solved problem by the VLDB people way back in the
60s or 70s when 0.6M was still large.
