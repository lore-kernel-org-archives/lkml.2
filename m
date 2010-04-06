Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0DFQuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 12:50:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54896 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0DFQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 12:50:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=paNRyHFxKdaaOc/Qu2jDFMf7wviQzi6al5gCQg+PyjBEKCJuJwgs434MOHNXk2WOAM
         HZFEeSsyxBTnexCHEeEo80FC+8KY7GzafcH8Zt2vSY5YlEHehtx4B0PCRGoFWKdmTqrm
         2sXS4FBYZmv/9kFdpbb0J9DQr6oDMitk32zQE=
Date: Tue, 6 Apr 2010 20:50:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryan Mallon <ryan@bluewatersys.com>, Hans Verkuil <hverkuil@xs4all.nl>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] power/ds2782: fix clientdata on removal
Message-ID: <20100406165007.GA27648@oksana.dev.rtsoft.ru>
References: <1270117664-29099-1-git-send-email-w.sang@pengutronix.de>
 <20100401104021.GA30121@oksana.dev.rtsoft.ru>
 <20100404141336.GA10176@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100404141336.GA10176@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 04, 2010 at 04:13:36PM +0200, Wolfram Sang wrote:
> On Thu, Apr 01, 2010 at 02:40:21PM +0400, Anton Vorontsov wrote:
> > On Thu, Apr 01, 2010 at 12:27:44PM +0200, Wolfram Sang wrote:
> > > Probably due to a copy & paste bug, clientdata was set again to the data
> > > structure (which is freed immediately afterwards) when it should be
> > > NULLed. Just remove the calls as the i2c-core does this automatically
> > > now.
> > > 
> > > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > > Cc: Ryan Mallon <ryan@bluewatersys.com>
> > > Cc: Hans Verkuil <hverkuil@xs4all.nl>
> > > Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> > > Cc: Jean Delvare <khali@linux-fr.org>
> > > ---
> > >
> > > Anton: If it is okay with you, I think this should go via the I2C-tree to
> > > ensure it comes after the needed modification of the i2c-core.
> > 
> > Sure thing.
> > 
> > Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> 
> Sorry, I misunderstood Jean. Would be nice if you could pick it up. Sorry for
> the noise.

Applied.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
