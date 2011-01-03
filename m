Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1ACJ3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 04:29:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54868 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab1ACJ3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 04:29:04 -0500
Subject: Re: [PATCH V8 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
From: Peter Zijlstra <peterz@infradead.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
References: <cover.1293820862.git.richard.cochran@omicron.at>
	 <503cd1fa268867573001cfc9bb5681ee3b5b32fa.1293820862.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 Jan 2011 10:29:09 +0100
Message-ID: <1294046949.2016.36.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-31 at 20:15 +0100, Richard Cochran wrote:
> +#define CLOCK_DISPATCH(clock, call, arglist) dispatch_##call arglist

How about you run something like:

 :% s/CLOCK_DISPATCH([^,]*, \([^,]*\), \([^)]*)\))/dispatch_\1\2/g

and remove that cruft all together?

