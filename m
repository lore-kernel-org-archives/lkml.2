Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0DLOUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:20:51 -0400
Received: from mail2.ruggedcom.com ([204.50.148.11]:25238 "EHLO
	mail2.ruggedcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab0DLOUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:20:49 -0400
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Apr 2010 10:20:49 EDT
Message-ID: <4BC32B00.1030600@ruggedcom.com>
Date: Mon, 12 Apr 2010 10:15:28 -0400
From: Michael Barkowski <michaelbarkowski@ruggedcom.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: hdlc_ppp: why no detach()?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Apr 2010 14:15:31.0496 (UTC) FILETIME=[9C1B7280:01CADA4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzyztof,

I am looking at your hdlc_ppp code and I don't understand: why is there
not the equivalent of fr_detach() in there?

pc8300_drv:cpc_remove_one() frees netdevs quite confidently but I wonder
how it can be so sure that there are not skbs in hdlc_ppp's tx_queue
associated with those devices before freeing them....

Even if you wanted to switch a device from PPP to Frame Relay, I don't
see the method right now.  If I may ask, please, what am I missing?

If you agree there is a need for detach(), I would be happy to work on
it and make a submission.

thanks for your time,

-- 
Michael Barkowski
RuggedCom, Inc.

