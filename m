Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965266Ab0COQAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:00:08 -0400
Received: from mail-gw21.credit-suisse.com ([198.240.212.9]:51818 "EHLO
	mail-gw21.credit-suisse.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965234Ab0COQAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:00:05 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 12:00:04 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?
Date: Mon, 15 Mar 2010 15:49:50 -0000
Message-ID: <5608FA8A997F1A46B7E985494F8478DD07930AF1@ELON17P32003A.csfb.cs-group.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Seeing TCP socket options (nodelay, cork, etc) in Linux procfs or elsewhere?
thread-index: AcrEVyU9eM2XHUpKQFmf/jFe5hS2zA==
From: "MacCana, Mike" <mike.maccana@credit-suisse.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Mar 2010 15:49:51.0550 (UTC) FILETIME=[263225E0:01CAC457]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi kernel folks,
 
I was wondering if there was a standard location to see TCP socket
options (eg, nodelay, cork, etc), perhaps via procfs or some other
means? I'd like to check whether arbitrary apps (for which I don't have
code) are using particular TCP options. 
 
Wandering round /proc/net hasn't turned up anything yet, and after a
quick:
socket.setsockopt(0, 1, 1)
to enable NODELAY I can't see any obvious difference in procfs or
netstat output (where other Unixes seem to put this info). hat's the
best way to see TCP options on sockets created by others' code?

Thanks,
 
Mike
 

Mike MacCana 
Engineer
RDO Low Latency Infrastructure 
CREDIT SUISSE
Phone: +44 (0)20 7883 5907 
Mobile: +44 (0)7547 004474 
mike.maccana@credit-suisse.com  
Five Canada Square, London, E14 4QJ. 
www.credit-suisse.com 


=============================================================================== 
 Please access the attached hyperlink for an important electronic communications disclaimer: 
 http://www.credit-suisse.com/legal/en/disclaimer_email_ib.html 
 =============================================================================== 
 
