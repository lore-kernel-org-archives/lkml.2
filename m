Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1JBWzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 18:55:43 -0400
Received: from imr3.ericy.com ([198.24.6.13]:55920 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1JBWzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 18:55:37 -0400
Date: Sun, 2 Oct 2011 15:54:34 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Randy Dunlap <rdunlap@xenotime.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111002225434.GA22333@ericsson.com>
References: <4E8655CD.90107@zytor.com>
 <201110020304.28288.rjw@sisk.pl>
 <4E87B885.50005@zytor.com>
 <201110021354.57995.rjw@sisk.pl>
 <4E88AF15.7000503@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E88AF15.7000503@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 02:36:05PM -0400, Randy Dunlap wrote:
> On 10/02/11 04:54, Rafael J. Wysocki wrote:
> > On Sunday, October 02, 2011, H. Peter Anvin wrote:
> >> On 10/01/2011 06:04 PM, Rafael J. Wysocki wrote:
> >>>
> >>> OK, I'm taking this as "5 years is fine by us". :-)
> >>>
> >>> And the recommended procedure for rotating keys seems to be (1) generate
> >>> a new key and (2) make as many people as you can sign it before the old
> >>> one expires, right?
> >>>
> >>
> >> (3) revoke the old key with a status code of "no longer in use", or just
> >> let it expire.
> >>
> >>>> Some people have decided to opt for an unlimited key, but that
> >>>> *requires* that you have a way to revoke the old key, which is why we
> >>>> are considering a key revocation escrow service.
> >>>
> >>> That service will be necessary anyway in case some keys are lost or
> >>> compromised.
> >>>
> >>> I wonder what the procedure of restoring kernel.org access in case one
> >>> has lost keys is supposed to be?
> >>
> >> Get a new key and get it re-signed.
> > 
> > Hmm.  That doesn't seem very practical if someone doesn't live close
> > to any other core kernel developers.
> > 
> > What number of signatures on the key will be regarded as sufficient?
> > 
> >> We can work out specific details at KS.
> > 
> > Well, the KS is going to be busy time this year I suppose. :-)
> > 
> > What about people who haven't been invited to the KS?
> 
> They (we) should start building a web of trust with local key signings.
> I'm already working on that in Portland, Oregon.
> 
Anyone in Silicon Valley looking for key signings, please get in touch.

Thanks,
Guenter
