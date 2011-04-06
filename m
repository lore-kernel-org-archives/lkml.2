Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1DFJhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:37:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65210 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1DFJhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:37:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Ib1SBN7s7yb20FVdxX725TWZninWm7sbQuLrjz5o6K2ndHIVICGZfJsp5Yg5Nz1lp2
         BmtwdMCkGddAV+UqDWJjGF8gEe8WzfGKwMXyz15xBmSQ0bZqcoQPH3jrrLlv5nbD/Fwn
         aNRO4THz89FC0VOhDY11OIw1rYfe0RTZNJDjg=
MIME-Version: 1.0
In-Reply-To: <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110301153438.GB15633@suse.de> <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 6 Apr 2011 11:36:46 +0200
Message-ID: <BANLkTikVpacjh1EsQQoaQRN3j-kxxjr7qA@mail.gmail.com>
Subject: Re: [PATCH 5/5] driver core: let dev_set_drvdata return int instead
 of void as it can fail
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-arm-kernel@lists.infradead.org,
        shiraz.hashim@st.com, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/6 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>
> I wasn't sure what to return when dev_set_drvdata is called with
> dev=NULL.  I choosed 0, but -EINVAL would be OK for me, too. What do you
> think?

Why not just BUG_ON(!dev)? Is there a case when you might call this
with dev==NULL that's not a driver bug?

Best Regards,
Michał Mirosław
