Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0JQVuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 17:50:25 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141]:41955 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab0JQVuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 17:50:24 -0400
Message-ID: <4CBB6F9B.6080803@cyconix.com>
Date: Sun, 17 Oct 2010 22:50:19 +0100
From: Tom Brown <sa212+emis@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Canonical ring-buffer code : SMP, single-reader/writer
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does anyone happen to know of any good example code that I could use in 
a driver for a simple single-reader, single-writer, ring buffer, on an 
SMP system?

My own code doesn't use any locks, but I'm concerned that it may be 
flaky. It's running on an 8-core processor, and I'm worried that I may 
be seeing SMP locking issues which I don't understand because the driver 
is on one core, while the user is on another core.

In my case, the producer is the driver, and the consumer is the user. I 
could just lock all the driver writes to the buffer and the driver's 
update of the shared 'last written' pointer, but that seems a really 
poor design.

Thanks -

Tom
