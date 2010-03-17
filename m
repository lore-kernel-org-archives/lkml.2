Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0CQBKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:10:32 -0400
Received: from bware04.bur.connect.com.au ([210.8.230.175]:60720 "EHLO
	bware04.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638Ab0CQBKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:10:31 -0400
X-Greylist: delayed 1371 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2010 21:10:31 EDT
Authentication-Results: bware04.bur.connect.com.au
	header.from=rhouse@smartchat.net.au; domainkeys=neutral (no sig)
Message-ID: <4BA026AB.2040203@smartchat.net.au>
Date: Wed, 17 Mar 2010 10:47:39 +1000
From: Ron House <rhouse@smartchat.net.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: 2.6.30 fails to detect hardware limitation requiring "noapic"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I hope this is the right place to report a kernel bug.

I have an Acer desktop, bog standard system.

My previous kernel 2.6.26 tells me that I need to set option "noapic", 
and then halts. This behaviour is correct.

Although it would be nice if the kernel dealt with noapic automatically, 
the attempt to make this happen in 2.6.30 doesn't work.

Booting with 2.6.30 gives me a bootup with many errors - USB ports not 
responding, failure to set the clock, and others. Then when it has 
finished booting, both the mouse and keyboard are dead. (But the system 
is running and can be accessed via ssh.)

When I reboot 2.6.30 with "noapic", it boots correctly.

My comment on this is that 2.6.26 is actually more useful than 2.6.30, 
because 2.6.30 doesn't give any clue as to what is wrong or how to fix 
it. If I hadn't previously had the experience with 2.6.26, I would have 
been hopelessly lost.

Hope this is useful, and thank you so much for the wonderful software!

-- 
Ron House.
Building Peace: http://peacelegacy.org
Australian Birds: http://wingedhearts.org
Principle of Goodness academic site: http://principleofgoodness.net
