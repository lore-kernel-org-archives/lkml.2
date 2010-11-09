Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0KIKas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:30:48 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63475 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab0KIKap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=i076OxzC9uhbdVY2DGKvDoHzCKnkgcMyBOpwRoeagWrCNjtUOF98jaubWBybZD+q8B
         /H6EiA7oSVCY0k3jYuCSgJUpKQExQo5mZRT0ZJa3UBL2VMEF6tZBNxNa3SKEJgTrGfYk
         aToD0sWHu357aShWZYrZUkPlymQLaJ4cBJM0U=
Subject: Re: [PATCH] mxcmmc: update the regulator support code to the
 latest API
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Chris Ball <cjb@laptop.org>, Daniel Mack <daniel@caiaq.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Linus Walleij <linus.ml.walleij@gmail.com>
In-Reply-To: <20101109101406.GW16938@pengutronix.de>
References: <1288656337.29881.13.camel@realization>
	 <20101102073932.GB6017@pengutronix.de>
	 <1288949275.3072.3.camel@realization>
	 <1289213595.3425.23.camel@realization>
	 <20101108143746.GA23201@void.printf.net>
	 <1289297390.3020.27.camel@realization>
	 <20101109101406.GW16938@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 11:30:38 +0100
Message-ID: <1289298638.3020.30.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On mar, 2010-11-09 at 11:14 +0100, Uwe Kleine-König wrote:
> On Tue, Nov 09, 2010 at 11:09:50AM +0100, Alberto Panizzo wrote:
> > 
> > This fix also the build problem introduced by my previous patch
> > due to unhanded API changes introduced by
> s/handed/handled/ ?
> 
> > commit:99fc5131018cbdc3cf42ce09fb394a4e8b053c74
> Linus wants to have the commit shortlog for references to other commits.
> After doing:
> 
> 	git config --global alias.one "show -s --pretty='format:%h (%s)'"
> 
> once you can simply use the output of
> 
> 	git one 99fc5131018cbdc3cf42ce09fb394a4e8b053c74
> 
> for that.

Ok Uwe,
I will update my patch pushing rules on this.
A cleaner patch will be sent soon.

Best Regards,

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

