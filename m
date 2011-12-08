Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab1LHUSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 15:18:44 -0500
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:41035 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1LHUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 15:18:43 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 15:18:41 EST
Message-ID: <4EE11903.7060809@genband.com>
Date: Thu, 08 Dec 2011 14:07:31 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: whatever happened to making setpriority POSIX-compliant?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2011 20:07:31.0969 (UTC) FILETIME=[04CE9F10:01CCB5E5]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18546.003
X-TM-AS-Result: No--4.002100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Back in 2008 there was a patch proposed to make setpriority() apply to 
processes as a whole:

[PATCH] make setpriority POSIX compliant; introduce PRIO_THREAD extension.

Ulrich agreed to it in theory, Christoph Hellwig proposed a way to make 
it backwards-compatible, and then nothing happened.

Is this something that we'd ever want to fix up, or is the current 
behaviour good enough?

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
