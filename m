Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1CRWJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:09:06 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:42954 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757237Ab1CRWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:09:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=KVSX3EPYuqd7KBc3CqSKqUQG9fVNUIWRCRGkY4fUGfdHcDBLP1J03OjM5gh2Qs9piw5l5SPYuQfBuHeTkpFCwIeVx7DRPjHPFk1+Q5hCPPbA5HLHhuJecShsoq4gvb9H;
Date: Fri, 18 Mar 2011 15:08:56 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>, axboe@kernel.dk
Subject: Re: minor doc correction: Documentation/iostats.txt: bit-size
 reference
Message-Id: <20110318150856.de589ea6.rdunlap@xenotime.net>
In-Reply-To: <4D83D188.3000909@tlinx.org>
References: <4D83D188.3000909@tlinx.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 173.50.240.230 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Mar 2011 14:41:28 -0700 Linda Walsh wrote:

> 
> 
> Documentation/iostats.txt describes fields in /proc/diskstats as
> 32-bit unsigned values that can wrap.
> 
> On a 64-bit system, it appears they are 64-bit unsigned values.
> 
> Should 'iostats.txt' describe fields as "unsigned, native-word-sized 
> values" or is my 64-bit system not behaving according to "spec"? ;-)

They are "unsigned long", so yes, that is basically your native-word-sized
values.  That text file was written in 2003 or earlier, so things have changed
a bit (or several bits) since then.

thanks.
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
