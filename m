Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab0LUW0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:26:14 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60140 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0LUW0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:26:07 -0500
Subject: Re: [PATCH V7 1/8] ntp: add ADJ_SETOFFSET mode bit
From: john stultz <johnstul@us.ibm.com>
To: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
References: <cover.1292512461.git.richard.cochran@omicron.at>
	 <880d82bb8120f73973db27e0c48e949014b1a106.1292512461.git.richard.cochran@omicron.at>
	 <AANLkTi=yGoFwYt4p_LeHtAQyYgmURspO-p57UdL0sUEZ@mail.gmail.com>
	 <20101221075612.GA13626@riccoc20.at.omicron.at>
	 <AANLkTimJd5pScKTiDxuYd-h+NevYbCusyvUAqmUDXe8h@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 14:25:55 -0800
Message-ID: <1292970355.2618.76.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 05:57 +0900, Kuwahara,T. wrote:

> How about this?
> 
> if (txc->modes & ADJ_OFFSET) {
> 	if (txc->constant == INT32_MIN) {
> 		/* step time */
> 	} else {
> 		/* slew time */
> 	}
> }

This looks like magic behavior. Sort of a "knock twice and then say the
password" interface. I don't see why that would be better then adding a
clear new mode flag?


> That said, I'm somehow against the idea of using the adjtimex syscall
> for that purpose.

Could you expand on why you don't like this?

thanks
-john


