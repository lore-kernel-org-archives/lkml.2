Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab2ETF05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 01:26:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2ETF0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 01:26:55 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] spi: Add SPI master controller for OCTEON SOCs.
To: David Daney <ddaney.cavm@gmail.com>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <4FB14B55.4070604@gmail.com>
References: <1336772086-17248-1-git-send-email-ddaney.cavm@gmail.com> <1336772086-17248-3-git-send-email-ddaney.cavm@gmail.com> <CAM=Q2csSQWbCOCQpubDok1=hmPvHU0MTEUg+-FGhp91=O5L6Hw@mail.gmail.com> <4FB14B55.4070604@gmail.com>
Date: Sat, 19 May 2012 23:26:53 -0600
Message-Id: <20120520052653.590673E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012 11:13:41 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> On 05/13/2012 10:46 PM, Shubhrajyoti Datta wrote:
> > Hi David,
> > A few comments.
> >
> > On Sat, May 12, 2012 at 3:04 AM, David Daney<ddaney.cavm@gmail.com>  wrote:
> [...]
> 
> >> +
> >> +#define DRV_VERSION "2.0" /* Version 1 was the out-of-tree driver */
> > This could be given a miss. As it is less meaningful once accepted.
> 
> 
> Well, this leads to the question, what is the purpose of the 
> 'MODULE_VERSION()' macro?  If I use that, I need to populate it with a 
> value.

Don't use MODULE_VERSION.  Just because it is there doesn't mean you
need to use it.  :-)  You'll notice that none of the other spi drivers
have it.

g.
