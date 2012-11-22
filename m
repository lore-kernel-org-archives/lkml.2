Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2KVS4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:56:52 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:60337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081Ab2KVS4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: w.sang@pengutronix.de, Mika Westerberg <mika.westerberg@linux.intel.com>,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, broonie@opensource.wolfsonmicro.com,
        khali@linux-fr.org, ben-linux@fluff.org, bhelgaas@google.com,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 0/3] ACPI 5 support for GPIO, SPI and I2C
Date: Thu, 22 Nov 2012 11:03:26 +0100
Message-ID: <12328820.crXDTeuliY@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CACRpkdZ_GT_k13wfihRp2=nSdf8bkJGt6SSQETBG7AouBzYXgg@mail.gmail.com>
References: <1353407384-26880-1-git-send-email-mika.westerberg@linux.intel.com> <79636467.nuLQX2FqW5@vostro.rjw.lan> <CACRpkdZ_GT_k13wfihRp2=nSdf8bkJGt6SSQETBG7AouBzYXgg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 22, 2012 10:43:28 AM Linus Walleij wrote:
> On Wed, Nov 21, 2012 at 10:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This patchset has been around for quite a while and went through a few
> > iterations, so I think it's as good as it gets at this point.
> >
> > I wonder if the GPIO / SPI / I2C maintainers have any objections against it or
> > would like the patches to be modified somehow?
> >
> > If not, then I'd like to take it for v3.8 into the linux-pm.git tree, because
> > the patches depend on some changes already in that tree.  Hopefully, that's OK.
> 
> For GPIO I want Grant to ACK this.
> 
> He has experience with both Device Tree and GPIO, knows what ACPI and
> UEFI is and is way better suited than me to give feedback on this kind of
> stuff.
> 
> So from my stance it's "neutral, whatever Grant says goes".

OK, we're waiting for a word from Grant, then. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
