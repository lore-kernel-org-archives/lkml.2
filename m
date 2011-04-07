Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab1DGWfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 18:35:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab1DGWfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 18:35:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [PATCH/RFC 4/6] ARM: move SH-mobile runtime PM to arm/common for sharing with other platforms
Date: Fri, 8 Apr 2011 00:35:26 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1302134569-22825-1-git-send-email-khilman@ti.com> <20110407165654.GD8052@linux-sh.org> <8739lu9eg6.fsf@ti.com>
In-Reply-To: <8739lu9eg6.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104080035.26989.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 07, 2011, Kevin Hilman wrote:
> Paul Mundt <lethal@linux-sh.org> writes:
> 
> > On Wed, Apr 06, 2011 at 05:02:47PM -0700, Kevin Hilman wrote:
> >> There is really nothing SH-mobile specific about this runtime PM
> >> implementation.  Any platform wanting to implement runtime PM based on
> >> simple clock gating can use this implementation.
> >> 
> >> Signed-off-by: Kevin Hilman <khilman@ti.com>
> >
> > This observation is wholly architecture agnostic, so it's not clear that
> > keeping it in arch/arm/common is any better. It seems that this would be
> > better suited for drivers/base/power/ with a generic Kconfig symbol.
> 
> Sounds fine to me.

Well, what platforms is the clock framework available on?

Rafael
