Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0CZXGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:06:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34375 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab0CZXGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:06:45 -0400
Date: Fri, 26 Mar 2010 23:06:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
       linux-arm-kernel@lists.infradead.org, linux-pcmcia@lists.infradead.org,
       Wolfram Sang <w.sang@pengutronix.de>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: pcmcia: fix checkpatch.pl issues in
	soc_common.c
Message-ID: <20100326230618.GD29179@n2100.arm.linux.org.uk>
References: <1269471898-26301-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <1269471898-26301-2-git-send-email-mroberto@cpti.cetuc.puc-rio.br> <20100324230729.GA21359@n2100.arm.linux.org.uk> <4BAB38B1.8080404@ru.mvista.com> <20100326181800.GB21682@n2100.arm.linux.org.uk> <cecb6d8f1003261457x69c319c1w884ade1746f81e8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cecb6d8f1003261457x69c319c1w884ade1746f81e8b@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 06:57:07PM -0300, Marcelo Jimenez wrote:
> On Fri, Mar 26, 2010 at 15:18, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Thu, Mar 25, 2010 at 01:19:29PM +0300, Sergei Shtylyov wrote:
> >>
> >>   I'd disagree in this case. Anybody will hardly grep for "mask:
> >> %s%s%s%s%s%sflags: %s%s%s%s%s%s".
> >
> > Well, I disagree on a matter of principle with you.  If you want to avoid
> > the line going over 80 columns, move the entire string onto the next line.
> > Then we can have the entire string intact _and_ we can have it fitting
> > within 80 columns.
> 
> This is no big deal. Also, I have already submitted the new patch and
> Valdis had a good point for egrep.

Sorry, I'm having stability issues with my MTA which inexplicably died
about 12 hours ago, presumably due to the level of crap flying around
the 'net nowadays.  This appears to be becoming a regular occurance in
the last week. ;(
