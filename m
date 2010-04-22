Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0DVHZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:25:30 -0400
Received: from poutre.nerim.net ([62.4.16.124]:60144 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab0DVHZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:25:29 -0400
Date: Thu, 22 Apr 2010 09:25:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Farid Hammane <farid.hammane@gmail.com>, ben-linux@fluff.org,
       Enrik.Berkhan@ge.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-algo-pca: fix all coding style issues in 
 i2c-algo-pca.c
Message-ID: <20100422092524.77b7aa84@hyperion.delvare>
In-Reply-To: <20100421235738.GB24384@pengutronix.de>
References: <1271877097-10939-1-git-send-email-farid.hammane@gmail.com>
	<20100421235738.GB24384@pengutronix.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 01:57:38 +0200, Wolfram Sang wrote:
> Hi Farid,
> 
> thanks for this approach. Have you checked that the binary is the same
> before/after your patch? If so, please mention in your patch description.
> 
> Also, always keep in mind that checkpatch helps to make code readable. Some of
> your changes should keep readability in mind not just fixing the warnings.
> 
> On Wed, Apr 21, 2010 at 09:11:37PM +0200, Farid Hammane wrote:
> > This patch fixes all coding style issues found by checkpatch.pl.
> 
> > 
> > Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> > ---
> >  drivers/i2c/algos/i2c-algo-pca.c |   74 ++++++++++++++++++++++---------------
> >  1 files changed, 44 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c-algo-pca.c
> > (...)
> > @@ -178,12 +178,12 @@ static int pca_rx_ack(struct i2c_algo_pca_data *adap,
> >  }
> >  
> >  static int pca_xfer(struct i2c_adapter *i2c_adap,
> > -                    struct i2c_msg *msgs,
> > -                    int num)
> > +		struct i2c_msg *msgs,
> > +		int num)
> 
> One more tab maybe?

Better use tab + spaces and align on the opening parenthesis. What
checkpatch.pl complains about here isn't the alignment, it's the use of
more than 8 consecutive spaces.

> > (...)
> > @@ -241,8 +244,10 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
> >  			completed = pca_address(adap, msg);
> >  			break;
> >  
> > -		case 0x18: /* SLA+W has been transmitted; ACK has been received */
> > -		case 0x28: /* Data byte in I2CDAT has been transmitted; ACK has been received */
> > +		case 0x18: /* SLA+W has been transmitted;
> > +			      ACK has been received */
> > +		case 0x28: /* Data byte in I2CDAT has been transmitted;
> > +			      ACK has been received */
> 
> First, check CodingStyle for how multiline comments should look like. For
> readability, I'd like to keep them single line, though. I think this could
> be done by rewording. Same for all following comments.

Please keep in mind that Farid doesn't know the code. He is "only"
helping with formatting cleanups. Asking him to reword the comments
doesn't seem wise. And there's nothing wrong with two-line comments as
above. The "preferred comment format" in CodingStyle is often
unrealistic IMHO, I'm not always following it in my own code.

I agree with all other comments.

-- 
Jean Delvare
