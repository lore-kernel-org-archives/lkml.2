Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1ASA4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 19:56:09 -0500
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:51170 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1ASA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 19:56:07 -0500
X-Greylist: delayed 15172 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Jan 2011 19:56:07 EST
Message-ID: <4D35FB33.1080305@genband.com>
Date: Tue, 18 Jan 2011 14:42:27 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: tool to send unsolicited neighbour advertisements?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jan 2011 20:42:29.0836 (UTC) FILETIME=[3964B8C0:01CBB750]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17902.001
X-TM-AS-Result: No--9.290300-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We're transitioning stuff to IPv6 and I've been trying (without much
luck) to find a standard tool for sending out unsolicited neighbour
advertisements for failover purposes.

Is there such a thing?  In ipv4 arping works fine.

Thanks,
Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
