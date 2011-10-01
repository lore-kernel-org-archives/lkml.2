Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab1JAO3C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 10:29:02 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51089 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab1JAO2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 10:28:55 -0400
X-Sasl-enc: fUSPZgMSlPQC5+IfPJh1XtcNpCVCBrbXM2AJ4wSDo4T+ 1317479334
Date: Sat, 1 Oct 2011 07:28:48 -0700
From: Greg KH <greg@kroah.com>
To: akwatts@ymail.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001142848.GA27058@kroah.com>
References: <4E8655CD.90107@zytor.com>
 <20110930235924.GA25176@kroah.com>
 <20111001141751.GA8937@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001141751.GA8937@zeus>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 01, 2011 at 09:17:51AM -0500, akwatts@ymail.com wrote:
> Greg, many thanks for providing these helpful hints for assessing 
> system integrity.
> 
> On Fri, Sep 30, 2011 at 04:59:24PM -0700, Greg KH wrote:
> > The compromise of kernel.org and related machines has made it clear that
> > some developers, at least, have had their systems penetrated.  As we
> > seek to secure our infrastructure, it is imperative that nobody falls
> > victim to the belief that it cannot happen to them.  We all need to
> > check our systems for intrusions.  Here are some helpful hints as
> > proposed by a number of developers on how to check to see if your Linux
> > machine might be infected with something:
> 
> I understand that git repos are protected from ex-post tampering by a
> rolling sha-1 hash. However, is it possible that code submissions were
> faked during the intrusion window and pulled by legitimate subsystem
> or system managers?
> 
> The intrusion on kernel.org has been dated as potentially weeks
> before 8/28 which means many tarballs (that common users rely on more
> than git) were posted after that.
> 
> Can we confirm a few things?

At this time, we are unable to discuss the events that took place due
to an ongoing investigation into the matter.  After that is complete, I
will be working to provide a report of what happened, but that will take
some time.

When www.kernel.org and git.kernel.org come back up, the kernels on them
will have been checked to be verified to be correct.  Everyone involved
is working as hard as they can to make that happen as soon as is
possible.

> c) can someone with verifiably clean code (i.e. not just downloads from
>    kernel.org) post checksums (md5,sha1,rmd160) for official tarball
>    releases since say 3/2011 (both full kernel and patches)?

You can do this today yourself from Linus's git tree if you want to,
it's very easy to script.  Just watch out for the fact that gzip puts
dates into the header, so you need to check the .tar file, not the
compressed ones.

thanks for your patience,

greg k-h
