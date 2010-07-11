Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0GKGqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:46:45 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:51696 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab0GKGqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:46:44 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
From: Bjoern Brandenburg <bbb@email.unc.edu>
In-Reply-To: <1278745706.4390.2.camel@Palantir>
Date: Sun, 11 Jul 2010 08:46:12 +0200
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Luca Abeni <lucabe72@email.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
Content-Transfer-Encoding: 8BIT
Message-Id: <21AA2C13-8831-47A2-9464-28E84DBD72B0@email.unc.edu>
References: <1278682707.6083.227.camel@Palantir> <1278685133.1900.201.camel@laptop> <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu> <1278745706.4390.2.camel@Palantir>
To: Raistlin <raistlin@linux.it>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10, 2010, at 9:08 AM, Raistlin wrote:

>> 
>> As a side note, almost all global EDF hard real-time admission tests can handle tasks with constrained deadlines transparently. However, as far as I can tell, they do not apply to SCHED_DEADLINE.
>> 
> This is the only part I am not sure I got... Can you explain me what do
> you mena by "they do not apply" ?

I was under the impression that the kernel implementation is a P-EDF implementation. Now it seems to me that it is in fact a "P-EDF with frequent migrations" implementation. I'd be hesitant to just assume that it "approximates G-EDF" sufficiently well to apply any of the published G-EDF tests.

- Björn

---
Björn B. Brandenburg
Ph.D. Student 
Dept. of Computer Science
University of North Carolina at Chapel Hill
http://www.cs.unc.edu/~bbb




