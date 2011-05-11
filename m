Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1EKQTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:19:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab1EKQTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:19:00 -0400
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
	 <1305109433.2914.208.camel@laptop>
	 <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
	 <1305121541.2914.213.camel@laptop>
	 <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
	 <1305122518.2914.224.camel@laptop>
	 <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 16:30:50 +0200
Message-ID: <1305124250.2914.225.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 16:22 +0200, Kay Sievers wrote:
> On Wed, May 11, 2011 at 16:01, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2011-05-11 at 15:52 +0200, Kay Sievers wrote:
> >>
> >> No, fixed time spans have never been a problem, and are not the
> >> example here. It's about the normal wall clock, that wakes up every
> >> minute and updates the numbers on the screen.
> >
> > 'wakes up every minute' sounds like a fixed time interval to me.
> 
> Right, but if the wall clock changes, it must not wait for the full
> minute to update the numbers, they need to update immediately with the
> new wall clock time. Stuff woke up every second in the past to do
> that, but that's not what we want today.

Again, nothing that couldn't be solved with a notifier of sorts.

