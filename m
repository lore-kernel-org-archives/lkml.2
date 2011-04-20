Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1DTX2O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:28:14 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47042 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751847Ab1DTX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:28:13 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX1/CEOMhpp/CqNEYXcWT+VioCfiS1u5VjqKHyHzOBH
	GQMmExTrx9aJoJ
Message-ID: <4DAF6C0B.3070009@gmx.de>
Date: Thu, 21 Apr 2011 01:28:11 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: iotop: khugepaged at 99.99% (2.6.38.3)
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there ...

While running firefox (>50 open Tabs), khugepaged jumped to 99.99%
(according to 'iotop').  I killed firefox and nearly all running
programs but khugepaged was still at 99.99% IO while the system
was almost idle. I waited about 10 minutes, no improvement, so
I rebooted the machine.

I observed this since 2.6.38 (I never run 2.6.37). This time the
system was still responsive. When I observed the same thing with
2.6.38.x (x<3), the system became unresponsive within minutes
after khugepaged hit 99%, see http://lkml.org/lkml/2011/4/7/306

All this happened five times since 2.6.38 became stable. It does
not happen at boot time, but days (or weeks) later.


Thomas

