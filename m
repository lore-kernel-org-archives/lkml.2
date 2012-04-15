Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab2DOMv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 08:51:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53668 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752966Ab2DOMvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 08:51:25 -0400
X-Authenticated: #18353093
X-Provags-ID: V01U2FsdGVkX19yknggXVVyovfpAbkjJW/3UdX9oiibT0DTEcHDXh
	XWIrV4zQsANXbJ
Message-ID: <4F8AC455.1090205@gmx.de>
Date: Sun, 15 Apr 2012 14:51:33 +0200
From: Karl Herz <karl.herz@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: How to change the interrupt flow handler from IO-APIC-fasteoi to
 level or edge?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to do some tests with level or edge interrupt flow handler 
instead of
the IO-APIC-fasteoi interrupt flow handler.
Is it possible to change the interrupt flow handler without changing the 
kernel?

TIA
Karl

