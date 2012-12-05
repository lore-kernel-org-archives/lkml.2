Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2LEQwN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:52:13 -0500
Received: from col0-omc2-s14.col0.hotmail.com ([65.55.34.88]:63315 "EHLO
	col0-omc2-s14.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab2LEQwM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:52:12 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 11:52:12 EST
X-Originating-IP: [122.172.17.241]
X-EIP: [4tU37xptYCpc6CzccFBO1ViEtqqTV3rW]
X-Originating-Email: [devendra-stark@outlook.com]
Message-ID: <COL002-W107B8681F385DB3959EF1DD85460@phx.gbl>
From: Devendra C <devendra-stark@outlook.com>
To: Bokhan Artem <art@eml.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Borislav Petkov (" <bp@alien8.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: kernel BUG at /build/buildd/linux-2.6.32/mm/mempolicy.c
Date: Wed, 5 Dec 2012 22:16:02 +0530
Importance: Normal
In-Reply-To: <50BF66A0.1050503@eml.ru>
References: <50BF66A0.1050503@eml.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 05 Dec 2012 16:46:02.0714 (UTC) FILETIME=[02FFF3A0:01CDD308]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Date: Wed, 5 Dec 2012 22:22:08 +0700
> From: art@eml.ru
> To: linux-kernel@vger.kernel.org
> Subject: kernel BUG at /build/buildd/linux-2.6.32/mm/mempolicy.c
> 
> Hello.
> 
> We have several servers with mongodb running. Each server has several mongodb 
> instances. Mongodb dataset is larger then availiable memory (mongodb uses 
> memory-mapped files for all disk I/O).
> 2.6.32 and 2.6.38 kernels periodically crash and crash happens only with mongodb 
> servers.
> 
> 2.6.38's trace is in attachment.
> For 2.6.32 I only have "kernel BUG at 
> /build/buildd/linux-2.6.32/mm/mempolicy.c:1489!"
> 
> Heed help! :)

Adding netdev to cc,

seems like the networking bug?

if so please attach some tcpdump traces, lspci -vv -n, 

please forgive me if its not related to networking. :(

thanks, 		 	   		  