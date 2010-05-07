Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0EGSoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:44:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:65267 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab0EGSoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=PvQXDy8UeI74Tt5wstLaGFu6ryx2/07Lz28bZQcObtwwNNelo30M4IrcOKuwUIlYe4
         vlFhwqlxFKYTP2ROHeR+21PlKeFD88PyrlmV12+0uxZT4BHPmxZWTYf2ayaiZJ70Hxvl
         6kRlWpY2px5KZ2gg7WhON6epHtprXohipyONA=
From: Christian Lamparter <chunkeey@googlemail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.34-rc6 pci bridge problems
Date: Fri, 7 May 2010 20:44:07 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-rc6-wl; KDE/4.4.3; x86_64; ; )
Cc: dhlii@dlasys.net, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net> <201005060909.58503.bjorn.helgaas@hp.com> <201005070946.41857.bjorn.helgaas@hp.com>
In-Reply-To: <201005070946.41857.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005072044.07682.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 May 2010 17:46:41 Bjorn Helgaas wrote:
> On Thursday, May 06, 2010 09:09:58 am Bjorn Helgaas wrote:
> > On Wednesday, May 05, 2010 01:59:55 pm Christian Lamparter wrote:
> > > On Wednesday 05 May 2010 20:41:26 David H. Lynch Jr. wrote:
> > > > When I build out of the wireless-testing git tree (puled today) 
> > > > 2.6.34-rc6 using my current systems .config I get a very quick error
> > > > on boot about PCI bridge windows.
> > > > googling the error indicates this is a know 2.6.34 problem and that 
> > > > there are fixes in other 2.6.34 trees.
> > > > I have been unable to find the actual patches or I would just apply 
> > > > them to wireless-testing.
> > 
> > I made significant changes in the way we handle PCI bridge windows,
> > and I'm eager to fix any issues in that area.  But "very quick error
> > on boot" doesn't give me any information to work with.
> > 
> > Please attach your complete dmesg output, serial console log (with
> > "ignore_loglevel"), digital photo of the error, or other specific
> > details.
> 
> Ping!  If there's a problem here, I want to fix it as soon as possible.
> Do you have any more details?  What error message did you google?

Pong! Unfortunately, I haven't heard any news about this pci bridge issue
from "David H. Lynch Jr.". But as you say: "Time for patching 2.6.34-rcX
regressions is running out". Therefore, David: please hurry up and post
what you are seeing. Most of oopses, can be easily captured with a serial
console (a setup is described in Documentation/serial-console.txt )

Regards,
	Chr
