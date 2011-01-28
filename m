Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1A1Myk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 07:54:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1A1Myi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 07:54:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V10 01/15] time: Introduce timekeeping_inject_offset
Date: Fri, 28 Jan 2011 13:54:00 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
References: <cover.1296124770.git.richard.cochran@omicron.at> <201101281305.37370.arnd@arndb.de> <1296218630.15234.334.camel@laptop>
In-Reply-To: <1296218630.15234.334.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101281354.01361.arnd@arndb.de>
X-Provags-ID: V02:K0:BnJST4lGrOPXijtbQxdLJrodN8NPZeNSRhYoLScYx0T
 or7i5NLa088+0t0udXgqWHtN238e7k4+KCbRwnWl+He23+bhWP
 hCIYy2Zgot0sFdkQAeeV6HfRv/awYk22PxsuM32W8+OHpMhTbb
 NPPwO/1hto6AIHHBkH5EVW6w8xvXB5mB27qtcZvC3nqdp1p6bk
 LcZttGLfLG4hXgn9X7M4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 January 2011, Peter Zijlstra wrote:
> > 
> > The problem is step 6. The output of git format-patch does not work when
> > sending with mutt. The easiest solution is to send with git send-email,
> > which does the same as mutt -H, but gets it right.
> 
> I use: formail -s sendmail -t < patches.mbox, but then, I use quilt mail
> to generate the mbox, not git.

I think in that case, quilt generates the correct 'From' headers both in
the actual email headers and in the body, so you can use any standard
email client to send it out.

	Arnd
