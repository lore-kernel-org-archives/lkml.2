Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0LZXXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 18:23:23 -0500
Received: from blu0-omc1-s20.blu0.hotmail.com ([65.55.116.31]:19283 "EHLO
	blu0-omc1-s20.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783Ab0LZXXW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 18:23:22 -0500
Message-ID: <BLU102-W8FAACC759DD93E3C0D7FBEB1F0@phx.gbl>
X-Originating-IP: [80.212.212.113]
From: Raj Kumar <rajkumar278@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: Regarding kernel work queue issues
Date: Mon, 27 Dec 2010 04:53:20 +0530
Importance: Normal
In-Reply-To: <alpine.LFD.2.00.1012261708070.2945@x980>
References: <20101221233942.GL1263@parisc-linux.org>,<4D1266F5.8040702@am.sony.com>,<alpine.LFD.2.00.1012261708070.2945@x980>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Dec 2010 23:23:20.0422 (UTC) FILETIME=[E2170860:01CBA553]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
Hi,
 
I have developed a device driver which is using default kernel work queue thread for deferring tasks. This work queue thread
while executing exits sometimes in function calls. It exits sometimes at one point and sometimes at another point without any panic. so the next time when the work is scheduled, it works normally.
 
can this problem be due to stack limit? 
 
Regards
Raj
  		 	   		  