Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab1JJULb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 16:11:31 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:39083 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab1JJUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 16:11:29 -0400
Date: Mon, 10 Oct 2011 14:11:28 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
cc: "Kristo, Tero" <t-kristo@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv9 03/18] TEMP: OMAP3xxx: hwmod data: add PRM hwmod
In-Reply-To: <4E934D79.4080000@ti.com>
Message-ID: <alpine.DEB.2.00.1110101411010.5205@utopia.booyaka.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com> <1316781986-30642-4-git-send-email-t-kristo@ti.com> <alpine.DEB.2.00.1110101320180.5205@utopia.booyaka.com> <4E934D79.4080000@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Cousson, Benoit wrote:

> Hi Paul,
> 
> On 10/10/2011 9:24 PM, Paul Walmsley wrote:
> > Hi Tero
> > 
> > On Fri, 23 Sep 2011, Tero Kristo wrote:
> > 
> > > This patch is temporary until Paul can provide a final version.
> > > 
> > > Signed-off-by: Tero Kristo<t-kristo@ti.com>
> > 
> > Here's an updated version of this one.  The one change is that the hwmod's
> > name is now "prm3xxx" to reflect that the register layout of this IP block
> > is quite different from its OMAP2 predecessors and OMAP4 successors.
> > This should avoid some of the special-purpose driver probing code.
> 
> This is not really aligned with the naming convention we've been using so far.
> In both cases, the hwmod should just be named "prm". If a version information
> is needed, then it should be added in the revision class field.
> 
> It will make the device creation even simpler and not dependent of the SoC
> version.
> I did not check the whole series, but I'm not sure we need a special treatment
> in the case of the prm.

OK, sounds like this needs more discussion, so will drop this patch from 
the pull request.


- Paul
