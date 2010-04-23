Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0DWNvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:51:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:41144 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab0DWNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:50:58 -0400
Date: Fri, 23 Apr 2010 06:52:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100423065248.3b0a98ab@infradead.org>
In-Reply-To: <20100423052439.GB4829@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<20100423052439.GB4829@ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 07:24:39 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> 
> Well, and now, if you do something like cat /dev/<your usb1.1 hdd> >
> /dev/null, you'll keep cpu on max frequency. Not a problem for new
> core i7, but probably big deal for athlon 64.

do you have facts not speculation for this? Does the athlon 64 really
keep its voltage high during idle? That would surprise me greatly...
(and if it does, does it matter? the clock is stopped anyway there)

the only place where my patch makes a real difference is when the cpu
is idle due to blocking IO! So do you have data that the athlon 64 gets
too hot if you select a high frequency during an idle period, where the
clock is already stopped?



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
