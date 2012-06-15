Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2FOHMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:12:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31369 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2FOHMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:12:36 -0400
Date: Fri, 15 Jun 2012 10:12:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Fengguang Wu <wfg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: automated warning notifications
Message-ID: <20120615071222.GZ13539@mwanda>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615014835.GA5695@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
> The lots of false warnings are a big problem. It makes the automated
> notification more noises than signals to people. So I end up disabling
> the sparse check totally..
> 

I do a basic sanity check of my emails before I send them.

Sometimes I do send false positives.  If the warning is introduced
by a very new code then probably the patch author can answer my
question off the top of her head.  Also I send some false positives
just to try learn what the rules are.

> In an average working day, 1-2 build errors will be caught and email
> notified. I guess there will be more sparse warnings if it's turned
> on.
> 
> Perhaps the sparse warnings can be enabled, but only sent to the patch
> author. If you and anyone else are interested, they could be sent to
> some mailing list, too. One thing I'm sure is, we probably never want
> to disturb the busy maintainers with these warnings.

Eventually I think we will want to set up a mailing list for this or
we will start sending duplicate messages.

regards,
dan carpenter

