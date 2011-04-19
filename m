Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab1DSPHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 11:07:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DSPHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 11:07:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v3] uio/pdrv_genirq: Add OF support
Date: Tue, 19 Apr 2011 17:07:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: John Williams <john.williams@petalogix.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        hjk@hansjkoch.de
References: <1303116654-5042-1-git-send-email-monstr@monstr.eu> <BANLkTin0krYi+MqngSQ5n-752vDa_a8ZtA@mail.gmail.com> <BANLkTin-qL3ppG1jRjBu3S16SWcNjD=3kA@mail.gmail.com>
In-Reply-To: <BANLkTin-qL3ppG1jRjBu3S16SWcNjD=3kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191707.40456.arnd@arndb.de>
X-Provags-ID: V02:K0:807IXlnJuz5H1KUHHCob8IWtfBoOgTJUOkOS/suriXB
 llVE+9y7+GyDxMst7UcN5Y9Mz702e6w2SRbVtYulAOAVQbU+BI
 iIC4TVZ8Ft48+3pUS183+u61J/3DQgXFVlSjnanCG/L+ZOPrqv
 H4mSz+NiIdpYhX/LvLjspTsEGiQFiW1XeaMZd649fcrByHgy4z
 zMOQQoSpVsTg5R9xr1+tw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Grant Likely wrote:
> > or whatever, as this would bind all instances matching vendor,device.
> >
> > So, the question I have is, how to handle bind per-instance?
> 
> By manipulating a property on the device instance of course!  :-)
> 
> Something like:  echo "generic-uio" >>
> /sys/devices/path/to/device/a-property-that-changes-the-driver-it-will-bind-to.
> 

But what code would create that in sysfs, and based on what properties
of the device? Should we do that for every platform device, or perhaps
for every one that has any resources?

	Arnd
