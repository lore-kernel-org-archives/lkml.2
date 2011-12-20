Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab1LTW3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:29:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34559 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab1LTW3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:29:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Ball <cjb@laptop.org>
Subject: Re: PCI suspend warnings in 3.2-rc6
Date: Tue, 20 Dec 2011 23:32:09 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Udo Steinberg <udo@hypervisor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>
References: <20111218151101.083bc530@x220.fritz.box> <201112190038.35760.rjw@sisk.pl> <m28vm85cxs.fsf@bob.laptop.org>
In-Reply-To: <m28vm85cxs.fsf@bob.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201112202332.09493.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 20, 2011, Chris Ball wrote:
> Hi,
> 
> On Sun, Dec 18 2011, Rafael J. Wysocki wrote:
> > On Sunday, December 18, 2011, Udo Steinberg wrote:
> >> When suspending to RAM, I'm getting a bunch of warnings from the PCI layer
> >> in Linux-3.2-rc6, which I didn't get with Linux-3.1. Please let me know if
> >> I should provide more information about platform, config, etc.
> >
> > This is a known issue with sdhci-pci and there's a patch fixing that,
> > hopefully in the maintainer's tree waiting for the next merge window
> 
> I'll push this for 3.2, thanks.

Thanks a lot!

Rafael
