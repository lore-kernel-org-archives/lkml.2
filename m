Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1EQVbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:31:23 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49366 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab1EQVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:31:21 -0400
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 May 2011 17:31:20 EDT
X-Sasl-enc: wou5lJib6aUUtKKTcCvKmlKSxb5pnK3Ep4KcJBAv04il 1305667292
Date: Tue, 17 May 2011 14:21:22 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] package: Makefile: add USB/IP userspace utilities
Message-ID: <20110517212122.GA13484@kroah.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
 <5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
 <20110517202300.GA7981@kroah.com>
 <BANLkTimCEFEVmdQM9J1=0QRE2NFcim6fAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimCEFEVmdQM9J1=0QRE2NFcim6fAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 02:13:01PM -0700, matt mooney wrote:
> On Tue, May 17, 2011 at 1:23 PM, Greg KH <greg@kroah.com> wrote:
> > On Sat, May 14, 2011 at 03:55:20AM -0700, matt mooney wrote:
> >> From: matt mooney <mfm@muteddisk.com>
> >>
> >> Add usbip-src-pkg target to generate a tarball of the userspace source.
> >>
> >> Signed-off-by: matt mooney <mfm@muteddisk.com>
> >> ---
> >>  scripts/package/Makefile |   15 ++++++++++++++-
> >
> > Is this really needed at this point in time?  I'd prefer to wait on it
> > before we get this code cleaned up a bit better if you don't mind.
> 
> Oh yeah, of course. I only added it because I thought you wanted me to
> add it now.

For some reason I thought it would be more, but there really isn't a way
to build the userspace code from the main root of the kernel tree is
there?

thanks,

greg k-h
