Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab2IQTim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:38:42 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:34494 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab2IQTil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:38:41 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As1TAIV7V1BV5h1yPGdsb2JhbABEhR4jhQCxXhkBAQEBNzSCIAEBBAE6HB4FEAgDRhQlChqIDQq6TxSRFWADlWGFcI0a
X-IronPort-AV: E=Sophos;i="4.80,438,1344204000"; 
   d="scan'208";a="413661957"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 17 Sep 2012 21:46:22 +0200
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120917194622.GA308@polaris.bitmath.org>
References: <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
 <20120916223003.GA2160@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161957490.2808@ubuntu>
 <20120917162705.GA2854@polaris.bitmath.org>
 <alpine.DEB.2.02.1209171356340.3412@ubuntu>
 <20120917184954.GA349@polaris.bitmath.org>
 <alpine.DEB.2.02.1209171446390.1963@ubuntu>
 <20120917191416.GA598@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917191416.GA598@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > So bottomline, I suspect we will need to bump to 0x20000 if you want to 
> > keep the current loop termination and udelay().
> 
> That is just crazy, since your code works with a 32ms maximum.

I am sorry, I misread the number of zeroes here. If you are saying
that fours times the current number is enough for the error rate to
drop off on your machine, then I think we should just do that. It is
the only change I can think of that is safe enough at this stage.

Given that the irqsoff latency on a normal machine can be as high as
200 ms or so, it does not seem all that strange.

Thanks,
Henrik
