Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0GIOY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:24:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:54201 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab0GIOY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:24:58 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278682707.6083.227.camel@Palantir>
References: <1278682707.6083.227.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 16:24:30 +0200
Message-ID: <1278685470.1900.206.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> Basically, from the scheduling point of view, what it could happen is
> that I'm still _NOT_ going to allow a task with runtime Q_i, deadline
> D_i and period P_i to use more bandwidth than Q_i/P_i, I'm still using D
> for scheduling but the passing of the simple in-kernel admission test
> Sum_i(Q_i/P_i)<1 won't guarantee that the task will always finish its
> jobs before D. 

But the tardiness would still be bounded, right? So its a valid Soft-RT
model?
