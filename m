Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab0HPLXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 07:23:21 -0400
Received: from lo.gmane.org ([80.91.229.12]:54101 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab0HPLXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 07:23:20 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Angel Tsankov <fn42551@fmi.uni-sofia.bg>
Subject: Kernel 2.6.30.10 hangs at boot time
Date: Mon, 16 Aug 2010 14:23:41 +0300
Message-ID: <i4b72v$mq5$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 212.73.151.246
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why does the kernel hang after printing "ACPI: Core revision 20090320" 
(line 147 in this dmesg log: http://pastebin.com/ed0sbSiR) though I pass 
"noacpi no-hlt" on the command line?

Regards,
Angel Tsankov

