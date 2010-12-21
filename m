Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab0LUId0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 03:33:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45846 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab0LUIdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 03:33:25 -0500
Subject: Re: [tip:sched/core] sched: Add 'autogroup' scheduling feature:
 automated per session task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mathieu.desnoyers@efficios.com, torvalds@linux-foundation.org,
        efault@gmx.de, pjt@google.com, markus@trippelsdorf.de,
        tglx@linutronix.de, oleg@redhat.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <AANLkTi=qZHFCk=ACohxc1yajLQObn+A3SQ4KE25gtSnL@mail.gmail.com>
References: <1290281700.28711.9.camel@maggy.simson.net>
	 <tip-5091faa449ee0b7d73bc296a93bca9540fc51d0a@git.kernel.org>
	 <AANLkTimRfVFmuMJzuirgsc37=RhC6zKX0C0YXhXO44O9@mail.gmail.com>
	 <1292851159.5021.2.camel@laptop>
	 <AANLkTi=3-FpuzXZ8xoEWCPhKrwydDOj0m4n-eEh-2BdT@mail.gmail.com>
	 <AANLkTi=qZHFCk=ACohxc1yajLQObn+A3SQ4KE25gtSnL@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 09:33:08 +0100
Message-ID: <1292920388.5021.206.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 21:23 +0530, Bharata B Rao wrote:
> 
> I missed adding the similar bits to RT in sched_dubug.c. If this
> approach is reasonable, I can send the next one with RT changes
> included. 

No that code needs a serious cleanup, I think you even (re-)introduced a
NULL pointer deref (but I didn't look too closely).

Simply re-instating the code that was removed isn't sufficient. 

Just write your patch as if its a new feature (and never even look at
the old code), you'll very probably end up with a much saner patch.
