Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab1EKQAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:00:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:54148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab1EKP6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:47 -0400
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTi=aOsRs4iS_j41=NNESC2rgmwtpbg@mail.gmail.com>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
	 <1305109433.2914.208.camel@laptop>
	 <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
	 <1305121541.2914.213.camel@laptop>
	 <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
	 <1305122518.2914.224.camel@laptop>
	 <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
	 <1305124250.2914.225.camel@laptop>
	 <BANLkTimvqAY9hwHujUVoQhN2eZQz-MVhgg@mail.gmail.com>
	 <1305125333.2914.229.camel@laptop>
	 <BANLkTi=aOsRs4iS_j41=NNESC2rgmwtpbg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 May 2011 17:11:20 +0200
Message-ID: <1305126680.2914.238.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-11 at 16:53 +0200, Kay Sievers wrote:
> 
> > Dunno, an eventfd that triggers every time someone calls adjtime() and
> > related?
> 
> I think, we are exactly not interested in adjtime() calls, but only in
> jumps in wall clock time. 

adjtime(), adjtimex() and settimeofday() are afaik the only ways to make
walltime jump. Anyway what are you arguing about, don't you want the
notification or do you insist on making the kernel slower for the 3
people who care about this daftness?

