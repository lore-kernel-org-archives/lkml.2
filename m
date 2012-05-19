Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2ESEUo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 00:20:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42105 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2ESEUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 00:20:42 -0400
Date: Fri, 18 May 2012 21:20:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/54] 3.0.32-stable review
Message-ID: <20120519042038.GB11939@kroah.com>
References: <20120518212656.GA4992@kroah.com>
 <20120519010105.GB18264@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120519010105.GB18264@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:01:05PM -0400, Steven Rostedt wrote:
> On Fri, May 18, 2012 at 02:26:56PM -0700, Greg KH wrote:
> > This is the start of the stable review cycle for the 3.0.32 release.
> > There are 54 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun May 20 21:15:57 UTC 2012.
> > Anything received after that time might be too late.
> 
> You really want people to work over the weekends don't you? ;-)

Sorry :)

I will wait until late on Monday before doing the real release, so you
do get an extra day here.

> Well, I set up a box to run ktest randconfigs and some other checks.
> Right now it's running on the 3.2.18-rc release. If I can sneak away
> from the misses, I may be able to kick off tests against these releases
> too. But I only have one box dedicated for this, so everything needs to
> be processed serially.

No rush, do it on Monday if needed.  Thanks for testing, I appreciate
it.

greg k-h
