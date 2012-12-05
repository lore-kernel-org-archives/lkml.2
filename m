Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2LEXdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:33:43 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:40835 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab2LEXdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:33:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Borislav Petkov <bp@alien8.de>,
        Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
        Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Look Ma, da kernel is b0rken
Date: Thu, 06 Dec 2012 00:38:34 +0100
Message-ID: <1430313.WKsQn6gbID@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121205152756.5afec12c@pyramind.ukuu.org.uk>
References: <20121205070901.GA12123@rhlx01.hs-esslingen.de> <20121205142935.GA12119@liondog.tnic> <20121205152756.5afec12c@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 05, 2012 03:27:56 PM Alan Cox wrote:
> On Wed, 5 Dec 2012 15:29:35 +0100
> Borislav Petkov <bp@alien8.de> wrote:
> 
> > On Wed, Dec 05, 2012 at 08:09:01AM +0100, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > drivers/pnp/pnpacpi/core.c: In function 'ispnpidacpi':
> > > drivers/pnp/pnpacpi/core.c:65:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > drivers/pnp/pnpacpi/core.c:66:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > drivers/pnp/pnpacpi/core.c:67:2: warning: logical 'or' of collectively
> > > exhaustive tests is always true [-Wlogical-op]
> > > 
> > > 
> > > That's already the second less enticing -Wlogical-op issue
> > > which was discovered by accident during less than two days
> 
> No it's not. It's been reported in bugzilla. I sent patches ages ago.
> They were ignored.

The last patch you sent wasn't ignored.  You got this comment from Bjorn:

http://thread.gmane.org/gmane.linux.acpi.devel/56753

that you didn't respond to, so I'm still unsure what to do with that patch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
