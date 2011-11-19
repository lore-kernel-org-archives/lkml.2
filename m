Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab1KSBrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 20:47:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab1KSBrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 20:47:20 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XgzihCSdOgwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=DOp0XZiC6rXYTvXu5DUA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [BUG] e1000: possible deadlock scenario caught by lockdep
From: Steven Rostedt <rostedt@goodmis.org>
To: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
In-Reply-To: <20111118151704.0000007b@unknown>
References: <1321579620.3533.29.camel@frodo>
	 <20111118085737.0000387f@unknown>  <20111118151704.0000007b@unknown>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 20:47:16 -0500
Message-ID: <1321667236.3533.59.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:17 -0800, Jesse Brandeburg wrote:

> this is a proposed patch to fix the issue:
> if it works for you please let me know and I will submit it officially
> through our process

Well, the one time I tested it, it didn't crash and it didn't give a
lockdep splat either. I'll add it and reboot it a few more times and
I'll holler if something bad happens.

Tested-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


