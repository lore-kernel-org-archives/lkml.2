Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab2J2VLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:11:46 -0400
Received: from mail.kernel.org ([198.145.19.201]:46354 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758546Ab2J2VLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:11:44 -0400
Date: Mon, 29 Oct 2012 14:11:42 -0700
From: Greg KH <greg@kroah.com>
To: Richard Retanubun <richardretanubun@ruggedcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Tang Nguyen <TangNguyen@ruggedcom.com>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        Arvid Brodin <Arvid.Brodin@xdin.com>,
        linux-usb mailing list <linux-usb@vger.kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Subject: Re: kmemleak report on isp1763 and sierra MC8705
Message-ID: <20121029211142.GA31351@kroah.com>
References: <508B0743.9040806@ruggedcom.com>
 <20121026233509.GA26646@kroah.com>
 <508EEB48.9070508@ruggedcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508EEB48.9070508@ruggedcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:47:04PM -0400, Richard Retanubun wrote:
> On 26/10/12 07:35 PM, Greg KH wrote:
> >On Fri, Oct 26, 2012 at 05:57:23PM -0400, Richard Retanubun wrote:
> >>Hi Guys,
> >>
> >>I am debugging a reported kmemleak involving a sierra wireless MC8705 connected
> >>through isp1763 on powerpc linux-3.0.22
> >
> >Does this also happen on 3.6.3?
> >
> >thanks,
> >
> >greg k-h
> 
> Hi Greg,
> 
> Unfortunately, it is not trivial for us to update the kernel on this platform,
> Is there a specific experiment/patch I should look at for 3.0.22?

I have no idea, given that 3.0.22 is based on 18 month old kernel, tens
of thousands of patches ago.

You are on your own here, sorry.

Best of luck,

greg k-h
