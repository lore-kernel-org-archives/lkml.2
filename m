Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab1CaMUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:20:55 -0400
Received: from snt0-omc1-s47.snt0.hotmail.com ([65.54.61.84]:25969 "EHLO
	snt0-omc1-s47.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194Ab1CaMUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:20:54 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Mar 2011 08:20:54 EDT
X-Originating-IP: [94.195.177.167]
X-Originating-Email: [johnkyr83@hotmail.com]
Message-ID: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
From: limp <johnkyr83@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Minimum time slice for relaible Linux execution
Date: Thu, 31 Mar 2011 13:13:55 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcvvnRrTPqoviC/WQfOBg2org+3G2A==
Content-Language: en-gb
X-OriginalArrivalTime: 31 Mar 2011 12:13:55.0681 (UTC) FILETIME=[1B482D10:01CBEF9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have developed a framework similar to a hypervisor that switches between
Linux and a RT domain.
As RT priority is of highest importance, I want to give more time to the RT
domain *but* I also want to give Linux adequate time for being able to
operate.

Could anyone advise me on how to determine the minimum possible time slice
that I can give to Linux so that it doesn't crash?

That is, if I periodically execute my RT domain every ms and then I switch
to Linux, what's the minimum time that should be given to Linux, until the
next RT domain execution? 

NOTE: The RT domain and Linux are not executed concurrently, i.e. the RT
domain is executed first and then Linux executes until the next RT domain
execution.

Thank you all in advance.

John K.


