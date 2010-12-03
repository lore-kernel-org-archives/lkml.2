Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0LCMkx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:40:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:59791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab0LCMkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:40:52 -0500
Subject: Re: Scheduler bug related to rq->skip_clock_update?
From: Peter Zijlstra <peterz@infradead.org>
To: "Bjoern B. Brandenburg" <bbb.lst@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
        Andrea Bastoni <bastoni@sprg.uniroma2.it>,
        "James H. Anderson" <anderson@cs.unc.edu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
References: <alpine.LNX.2.00.1011202315290.8927@jupiter-cs.cs.unc.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Dec 2010 13:41:05 +0100
Message-ID: <1291380065.32004.2059.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bjoern,

sorry the the slow response, and sadly I'll have to ask a little bit
more patience yet :/

It a nice find and I'll look into it as soon as possible.
