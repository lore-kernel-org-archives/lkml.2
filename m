Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0I3Da4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:30:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47248 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752725Ab0I3Daz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:30:55 -0400
Date: Wed, 29 Sep 2010 20:31:11 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the i.MX
 tree
Message-ID: <20100930033110.GA5762@opensource.wolfsonmicro.com>
References: <20100930112302.e554d367.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930112302.e554d367.sfr@canb.auug.org.au>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 11:23:02AM +1000, Stephen Rothwell wrote:

> The former removed that code that the latter changed.  I just used the
> former.

> The latter was just changing some names, so ti may be able to be
> integrated into the former.

Though doing that would break bisection.  The other option would be to
revert the bit of the multi-component change that does the rename which
I think should be safe - Sacha, Liam, does that seem sensible?  There is
the issue with other potential non-audio users of the SSI to be
considered.
