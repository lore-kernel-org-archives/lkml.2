Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0HIToD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:44:03 -0400
Received: from ns.store20.com ([212.7.7.16]:44215 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901Ab0HIToB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:44:01 -0400
Subject: Re: [BISECTED/2.6.35+] Regression: Machine runs really slowly
 after commit f12a15be
From: Priit Laes <plaes@plaes.org>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1281380498.2444.2.camel@localhost.localdomain>
References: <1281186941.23274.5.camel@chi>
	 <1281380498.2444.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 09 Aug 2010 22:43:57 +0300
Message-ID: <1281383037.17867.9.camel@chi>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, E, 2010-08-09 kell 12:01, kirjutas john stultz:
> On Sat, 2010-08-07 at 16:15 +0300, Priit Laes wrote:
> > Following commit makes my Dell Latitude D610 machine (x86_32) run really-really slow...
> > 
> > f12a15be63d1de9a35971f35f06b73088fa25c3a is the first bad commit
> > commit f12a15be63d1de9a35971f35f06b73088fa25c3a
> > Author: John Stultz <johnstul@us.ibm.com>
> 
> Could you both please provide the output of:
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource 
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource

This is with kernel 2.6

cat /sys/devices/system/clocksource/clocksource0/current_clocksource
hpet
cat /sys/devices/system/clocksource/clocksource0/available_clocksource
hpet acpi_pm 


Päikest,
Priit ;)
