Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab0EIJMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 05:12:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:57561 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0EIJMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 05:12:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4BE67C65.9080801@s5r6.in-berlin.de>
Date: Sun, 09 May 2010 11:12:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: florian@mickler.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] get_maintainer.pl: only list maintainers by default
References: <1273354364-6016-1-git-send-email-florian@mickler.org>	 <1273354778-6129-1-git-send-email-florian@mickler.org>	 <1273358674.704.77.camel@Joe-Laptop.home>	 <4BE5F286.1020503@s5r6.in-berlin.de>	 <1273362666.704.104.camel@Joe-Laptop.home>	 <4BE60045.3040600@s5r6.in-berlin.de> <1273366633.704.109.camel@Joe-Laptop.home>
In-Reply-To: <1273366633.704.109.camel@Joe-Laptop.home>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> I'd send you Linus' original email from 2007,
> but you'd already commented on that, so for now,
> unless you come up with some stats that support
> your view, I'll stand by mine.

I don't remember the particular mail of his that you refer to.  But I
suspect he recommended to /look/ at the history, not exactly to /blindly
grep/ through the history and Cc all addresses that got caught.

If the thread starter had looked at the history of fs/eventpoll.c, he
wouldn't have Cc'd me.  A 5 seconds glance at gitk fs/eventpoll.c would
have sufficed.
-- 
Stefan Richter
-=====-==-=- -=-= -=--=
http://arcgraph.de/sr/
