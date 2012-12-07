Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2LGPkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 10:40:22 -0500
Received: from smarthost01.mail.zen.net.uk ([212.23.1.1]:51967 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756397Ab2LGPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 10:40:21 -0500
X-Greylist: delayed 2699 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2012 10:40:21 EST
Message-ID: <1354894812.13000.59.camel@linaro1.home>
Subject: Re: [PATCH] ARM: ftrace: Ensure code modifications are synchronised
 across all cpus
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Rabin Vincent <rabin@rab.in>,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Dec 2012 15:40:12 +0000
In-Reply-To: <1354894134.17101.44.camel@gandalf.local.home>
References: <1354817466.30905.13.camel@linaro1.home>
	 <1354821581.17101.17.camel@gandalf.local.home>
	 <1354872138.3176.15.camel@computer5.home>
	 <1354888985.17101.41.camel@gandalf.local.home>
	 <1354892111.13000.50.camel@linaro1.home>
	 <1354894134.17101.44.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-07 at 10:28 -0500, Steven Rostedt wrote:
> I'm not NACKing your previous patch, I was just suggesting to bring ARM
> up to the future :-)

ARM is the future ;-)

> 
> I have no problems with the patch, but I just want to put it out there
> that there's better ways. It's part of the remove stomp_machine()
> crusade ;-)

Indeed, when I first cam across stop_machine(), I though 'yuck!',
especially when I realised Linux scheduling seems to mean the system
goes idle until the the next tick triggers scheduling of these 'highest
priority' threads.

-- 
Tixy

