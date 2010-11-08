Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0KHPZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:25:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46885 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0KHPZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:25:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PO8tinDvZ4YxYy++Cs+tt8qE3puY2x+BFFsVY/6/x1xCNTMb0c8VmplfLKf4az13ow
         PJkL0MX4Q7YvsG1GrTIAIdT0PF1HGtBA3gARNV9vtCebRIAGyd+CX973ZLohWr6FBa2i
         s1iWg5ERiOjAuG3T60ONbg3Ya3hMrgmI3zJ5k=
Subject: Re: [PATCH] mxcmmc: Add the ability to bind a regulator to manage
 the MMC card voltage
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Eric =?ISO-8859-1?Q?B=E9nard?= <eric@eukrea.com>,
        Fabio Estevam <fabioestevam@yahoo.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <20101108143746.GA23201@void.printf.net>
References: <1288656337.29881.13.camel@realization>
	 <20101102073932.GB6017@pengutronix.de>
	 <1288949275.3072.3.camel@realization>
	 <1289213595.3425.23.camel@realization>
	 <20101108143746.GA23201@void.printf.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 16:25:41 +0100
Message-ID: <1289229941.7417.0.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On lun, 2010-11-08 at 14:37 +0000, Chris Ball wrote:
> Hi Alberto,
> 
> On Mon, Nov 08, 2010 at 11:53:15AM +0100, Alberto Panizzo wrote:
> > > > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > Chris,
> > Please, any comment on this one?
> 
> This is pushed to mmc-next and queued for 2.6.38 now.  Thanks!
> 

Ok,
Thank you!

-- 
Alberto!

        Be Persistent!
                - Greg Kroah-Hartman (FOSDEM 2010)

