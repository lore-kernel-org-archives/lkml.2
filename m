Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0GIOTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 10:19:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:50981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0GIOTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 10:19:11 -0400
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
Date: Fri, 09 Jul 2010 16:18:53 +0200
Message-ID: <1278685133.1900.201.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:

>  - using periods for calculating the tasks' bandwidth and then using   
>    deadlines for scheduling the tasks is going to work, but the
>    admission control test that you would need for ensuring anybody
>    will make its deadline is waaay more complex than Sum_i(BW_i)<1, even
>    for uniprocessors/partitionig. That one instead would gives you just
>    a very basic guarantee that the design in not completely broken
>    (formally, I think I should say it is only a necessary
>    condition :-)).

Happen to have a paper handy that explains all this in a concise way? 
