Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2AHPM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:12:26 -0500
Received: from blu0-omc1-s32.blu0.hotmail.com ([65.55.116.43]:39813 "EHLO
	blu0-omc1-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936Ab2AHPMZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:12:25 -0500
Message-ID: <BLU166-W17355941BF324D0DC14C90C49B0@phx.gbl>
X-Originating-IP: [31.150.19.132]
From: Jan-Erik Lange <jan0385@hotmail.de>
To: <linux-kernel@vger.kernel.org>
Subject: IPC implementation in Linux
Date: Sun, 8 Jan 2012 16:12:24 +0100
Importance: Normal
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Jan 2012 15:12:25.0164 (UTC) FILETIME=[ED88D8C0:01CCCE17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,
 
I have a question concerning the implementation of the IPC mechanisms in Linux. Unfortunately I didn't find any further information in the web.
 
1. There is the Shared memory mechanism: So far as I know it maps some processes address space to the address space
of another process. Through this address space the two processes can exchange information. This way of IPC is quite replicable 
for me.
 
2. But how are the IPC mechanisms like message queues or pipes/FIFOs realized? Are they workng with a shared address space too?
 
Best regards
 
Jan 		 	   		  