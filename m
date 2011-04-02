Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab1DBVqi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 17:46:38 -0400
Received: from snt0-omc4-s19.snt0.hotmail.com ([65.55.90.222]:55270 "EHLO
	snt0-omc4-s19.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756944Ab1DBVqh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 17:46:37 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Apr 2011 17:46:37 EDT
Message-ID: <SNT125-W289B1DC285FE71DB4ED9F8C3A10@phx.gbl>
X-Originating-IP: [71.112.243.235]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <lenb@kernel.org>, <sfr@canb.auug.org.au>
CC: <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] APM: delete APM in Linux-2.6.40
Date: Sat, 2 Apr 2011 14:40:27 -0700
Importance: Normal
In-Reply-To: <alpine.LFD.2.02.1103240336590.4529@x980>
References: <alpine.LFD.2.02.1103232321070.3848@x980>
 <20110324154505.934a56a0.sfr@canb.auug.org.au>,<alpine.LFD.2.02.1103240336590.4529@x980>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Apr 2011 21:40:27.0407 (UTC) FILETIME=[94C171F0:01CBF17E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +Why: Microsoft deleted APM from Windows as of Vista in in 2006.

To be more precise, support for all hardware that do not support ACPI.
Also required for Vista and later is a 586 processor with TSC, such as Intel Pentium or later
 
Yuhong Bao 		 	   		  