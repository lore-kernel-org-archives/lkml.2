Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab2ABNtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 08:49:24 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:57108 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2ABNtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 08:49:21 -0500
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jan 2012 08:49:21 EST
Date: Mon, 2 Jan 2012 14:41:38 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: "P." <mailme667@yahoo.co.uk>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>, akpm@linux-foundation.org
Subject: Re: [PATCH resend] rtc: Fix alarm rollover when day or month is
 out-of-range
Message-ID: <20120102144138.034f5831@linux.lan.towertech.it>
In-Reply-To: <20111231003552.GB22266@elie.Belkin>
References: <1325289236.85273.YahooMailClassic@web27003.mail.ukl.yahoo.com>
	<20111231003552.GB22266@elie.Belkin>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Dec 2011 18:35:52 -0600
Jonathan Nieder <jrnieder@gmail.com> wrote:

> From: Ben Hutchings <ben@decadent.org.uk>
> Date: Thu, 29 Dec 2011 16:41:56 +0100
> 
> Commit f44f7f96a20a ('RTC: Initialize kernel state from RTC')
> introduced a potential infinite loop.  If an alarm time contains a
> wildcard month and an invalid day (> 31), or a wildcard year and an
> invalid month (>= 12), the loop searching for the next matching date
> will never terminate.  Treat the invalid values as wildcards.
> 
> Fixes <http://bugs.debian.org/646429>, <http://bugs.debian.org/653331>
> 
> Reported-by: leo weppelman <leoweppelman@googlemail.com>
> Reported-by: "P. van Gaans" <mailme667@yahoo.co.uk>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>


 Seems reasonable, ty.


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

