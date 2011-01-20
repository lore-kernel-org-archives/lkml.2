Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1ATUkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:40:06 -0500
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:60184 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab1ATUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:40:04 -0500
Message-ID: <4D389D8B.7010301@genband.com>
Date: Thu, 20 Jan 2011 14:39:39 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: why does /proc/sys/fs/file-nr not match total of /proc/<pid>/fd entries?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2011 20:39:41.0588 (UTC) FILETIME=[29EF9D40:01CBB8E2]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17906.001
X-TM-AS-Result: No--9.556100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Someone asked me a question that I couldn't answer, so I'm passing it on
to you.

Why do the values in /proc/sys/fs/file-nr not match up with the value
given by "ls -al /proc/[0-9]*/fd/ | grep '>' | wc -l" ?


For instance, on my desktop /proc/sys/fs/file-nr gives "9728    0
306699" but the other command gives "2894".


Where is the discrepancy coming from?

Thanks,
Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
