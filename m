Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1K2JYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:24:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:39705 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab1K2JYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:24:01 -0500
Message-ID: <1322558612.2921.182.camel@twins>
Subject: Re: [PATCH 0/4] delayacct: save max CPU/IO/SWAP/RECLAIM delays
From: Peter Zijlstra <peterz@infradead.org>
To: Satoru Moriya <satoru.moriya@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "nagar@watson.ibm.com" <nagar@watson.ibm.com>,
        "kobayashi.kk@ncos.nec.co.jp" <kobayashi.kk@ncos.nec.co.jp>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Tue, 29 Nov 2011 10:23:32 +0100
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
References: <65795E11DBF1E645A09CEC7EAEE94B9CB574E70D@USINDEVS02.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 17:44 -0500, Satoru Moriya wrote:
> In the latency sensitive systems, we usually focus on the worst latency.
> And so, it is useful to save max delays into the per-task delay
> accounting functionality.
> 
> Example output:
> (on 100 concurrent dd reading sparse files w/ 1 dd writing a file)
> 
> CPU             count     real total  virtual total    delay total      delay_max  delay average
>                   222       45993008       74603882        7637295        3691858          0.034ms
> IO              count    delay total      delay max  delay average
>                     2       21812073       12728672             10ms
> SWAP            count    delay total      delay max  delay average
>                     0              0              0              0ms
> RECLAIM         count    delay total      delay_max  delay average
>                     2         348488         211985              0ms
> 
> Any comments are welcome.

No!!!

Linus told us to be bastards, so there you have it.

There's way too many different accounting crap thingies around. And now
I get a patch without any justification what so ever. So no, piss off.
