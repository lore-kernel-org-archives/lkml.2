Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab1CCVy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:54:26 -0500
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:33490 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab1CCVyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:54:24 -0500
Message-ID: <4D700A5B.2000807@genband.com>
Date: Thu, 03 Mar 2011 15:38:35 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Nico_Sch=FCmann?= <dev@nico22.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Network link detection
References: <20110303193006.GA29129@svh.nico22.de>
In-Reply-To: <20110303193006.GA29129@svh.nico22.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Mar 2011 21:38:36.0361 (UTC) FILETIME=[5A2CAB90:01CBD9EB]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17990.002
X-TM-AS-Result: No--9.325400-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 01:30 PM, Nico Schümann wrote:
> Dear kernel developers,
> 
> currently I'm looking for a way to find out whether a network link went 
> down or up. Of course there is mii-tool, which can watch devices, too.
> 
> Unfortunately, I was not able to find out a way to be notified about 
> link status changes asynchronously. Is there a way? I'm looking for 
> something like "inotify for link states".

You might look at whether you could write a kernel module to register
for NETDEV_CHANGE notifications and pass that back to userspace.

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
