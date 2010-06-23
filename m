Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0FWWcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:32:18 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:33637 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab0FWWcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:32:17 -0400
Message-ID: <4C228B49.5000408@euromail.se>
Date: Thu, 24 Jun 2010 00:31:37 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] MAINTAINERS: Add an entry for the input MT protocol
References: <1277330664-13884-1-git-send-email-rydberg@euromail.se> <1277332072.31591.92.camel@Joe-Laptop.home>
In-Reply-To: <1277332072.31591.92.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1ORYTt-000670-Bc.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1ORYTt-000670-Bc a4db0addecd6a5cbc958178aa33049e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Thu, 2010-06-24 at 00:04 +0200, Henrik Rydberg wrote:
>> This patch adds a maintainer for the input multitouch (MT) protocol,
>> such that get_maintainer.pl selects it whenever an MT event is present
>> in the patch.
> 
>> +MULTITOUCH INPUT MT PROTOCOL
>> +M:	Henrik Rydberg <rydberg@euromail.se>
>> +L:	linux-input@vger.kernel.org
>> +S:	Maintained
>> +F:	Documentation/input/multi-touch-protocol.txt
>> +K:	ABS_MT
> 
> That doesn't seem to match anything other than multitouch
> stuff, but it's probably best to specify the pattern as
> much as possible.
> 
> If you didn't know, K: entries can be entered as perl regex,
> so maybe something like:
> 
> K:	\b(ABS|SYN)_MT_
> 

Thanks for the info. However, since every application using the MT protocol by
necessity uses at least one event called ABS_MT*, it should be fine as is,
shouldn't it?

Henrik

