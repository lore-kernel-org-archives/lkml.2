Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1ECSkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:40:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50005 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754297Ab1ECSke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:40:34 -0400
Date: Tue, 3 May 2011 19:40:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Intel SST driver update
Message-ID: <20110503184032.GK1762@opensource.wolfsonmicro.com>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
 <20110503171538.GH2893@sirena.org.uk>
 <20110503193612.22833754@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503193612.22833754@lxorguk.ukuu.org.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 07:36:12PM +0100, Alan Cox wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > What's the plan for moving these out of staging?  Quite a few of these
> > patches feel like moves in the wrong direction, adding more code that's
> > going to have problems with mainline rather than addressing the issues
> > that prevent merges.

> There is a separate driver being written. In the meantime this driver is
> getting updated and maintained because in the real world people have
> customers and products to deliver.

Sure, I was just asking if there was a plan to work on this properly -
the normal expectation in staging is that we'll see in place refactoring
and this series clearly isn't that.  You seem a little defensive here...

> It might as well therefore be maintained in tree as out. That seems to
> serve Linux users rather better.

Of course, as do most of us, I was mostly making sure that there was a
plan here.
