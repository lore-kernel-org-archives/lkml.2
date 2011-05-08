Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab1EHFJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 01:09:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:38544 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750878Ab1EHFJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 01:09:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+fYO4xfuGf+B4sV68aHCOyIg4UQqdBJSbDpRFVv5
	qFuCcR+XPa3GP+
Subject: Re: -longterm kernels
From: Mike Galbraith <efault@gmx.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Greg KH <greg@kroah.com>, stable@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110507145503.GA2276@redhat.com>
References: <201105030110.p431A5W0005426@hera.kernel.org>
	 <20110504223605.GA5967@kroah.com> <20110505145854.GA4670@redhat.com>
	 <20110505152501.GA14146@kroah.com>  <20110507145503.GA2276@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 May 2011 07:09:21 +0200
Message-ID: <1304831361.6326.21.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-07 at 16:55 +0200, Stanislaw Gruszka wrote:
> On Thu, May 05, 2011 at 08:25:01AM -0700, Greg KH wrote:
> > > BTW, Greg, perhaps -logterm releasing policy should be revised somehow.
> > > Currently we have .32, .33, .34, .35 -longterm, what is kind a much.
> > 
> > It's not "much" if you rely on that kernel version, right?
> 
> Yes, but maybe would be better if they do not relay on some versions in
> long term manner, and i.e. .33 users would use .32 and .34 users would
> use .35 instead?

Ceasing to rely upon .33 isn't a trivial choice for -rt tree users.

	-Mike

