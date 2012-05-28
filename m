Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2E1Hgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 03:36:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46315 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2E1Hgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 03:36:31 -0400
Date: Mon, 28 May 2012 08:36:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alim Akhtar <alim.akhtar@gmail.com>, Alim Akhtar <alim.akhtar@samsung.com>,
        linux-samsung-soc@vger.kernel.org, vinod.koul@intel.com,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 0/1] dmaengine/amba-pl08x: Add support for s3c64xx
	DMAC
Message-ID: <20120528073609.GG24149@n2100.arm.linux.org.uk>
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com> <CACRpkdZC8LOOLkWbrPbXN_nKaw-WvueusYDyrX48Q1Pcdwv3Aw@mail.gmail.com> <CAGOxZ52w1nn8g4d_vuNAzjA9qYZ1=yEfihFvSOK+pBz=ZD=J7Q@mail.gmail.com> <CACRpkdZO=B9gWkhvgf4Ewi1GKibFxki36uF06ispQzDK7T+4sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZO=B9gWkhvgf4Ewi1GKibFxki36uF06ispQzDK7T+4sA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 12:41:42PM +0800, Linus Walleij wrote:
> On Thu, Dec 8, 2011 at 9:03 AM, Alim Akhtar <alim.akhtar@gmail.com> wrote:
> 
> > Hello Linus,
> > sorry for the delay in submitting V3 of the pl080 patches for s3c64xx.
> > I am very busy with my current assignment.
> > I will come back to my patch series incorporating yours and Viresh
> > suggestions in v3.
> 
> Ping on this, is there something in specific that you need help on here?
> We really need to get rid of this forked code, and it should be beneficial
> to S3C because we have fixed a lot of bugs in the PL08x driver now,
> plus it'll likely be a prerequisite to DT support for S3C.

So this hasn't gone in?

This is going to be painful - I have 40 odd patches to PL08x converting it
to virt-dma now...  It's probably going to be easier for the S3C conversion
to be based upon my work rather than me having to rework all those patches.
