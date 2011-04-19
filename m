Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab1DTABa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:01:30 -0400
Received: from kroah.org ([198.145.64.141]:43195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab1DTAB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:01:28 -0400
Date: Tue, 19 Apr 2011 16:58:12 -0700
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirqus@gmail.com>
Subject: Re: [PATCH v2] driver core: let dev_set_drvdata return int instead
 of void as it can fail
Message-ID: <20110419235812.GA4619@kroah.com>
References: <BANLkTi=MjDqawZx=+fKjaAs5SPfGQDEgVQ@mail.gmail.com>
 <1302547378-14639-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1302547378-14639-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 08:42:58PM +0200, Uwe Kleine-König wrote:
> Before commit
> 
> 	b402843 (Driver core: move dev_get/set_drvdata to drivers/base/dd.c)
> 
> calling dev_set_drvdata with dev=NULL was an unchecked error. After some
> discussion about what to return in this case removing the check (and so
> producing a null pointer exception) seems fine.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> @Viresh: as I didn't choose to return -EINVAL I didn't add your Reviewed-by:

I'm confused by this thread, care to resend all of these in a series
against the latest linux-next tree?

thanks,

greg k-h
