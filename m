Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0EGPqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:46:55 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40272 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756615Ab0EGPqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:46:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: 2.6.34-rc6 pci bridge problems
Date: Fri, 7 May 2010 09:46:41 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; x86_64; ; )
Cc: dhlii@dlasys.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
References: <4BDC001F.9050202@dlasys.net> <201005052159.55871.chunkeey@googlemail.com> <201005060909.58503.bjorn.helgaas@hp.com>
In-Reply-To: <201005060909.58503.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005070946.41857.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 06, 2010 09:09:58 am Bjorn Helgaas wrote:
> On Wednesday, May 05, 2010 01:59:55 pm Christian Lamparter wrote:
> > On Wednesday 05 May 2010 20:41:26 David H. Lynch Jr. wrote:
> > > When I build out of the wireless-testing git tree (puled today) 
> > > 2.6.34-rc6 using my current systems .config I get a very quick error
> > > on boot about PCI bridge windows.
> > > googling the error indicates this is a know 2.6.34 problem and that 
> > > there are fixes in other 2.6.34 trees.
> > > I have been unable to find the actual patches or I would just apply 
> > > them to wireless-testing.
> 
> I made significant changes in the way we handle PCI bridge windows,
> and I'm eager to fix any issues in that area.  But "very quick error
> on boot" doesn't give me any information to work with.
> 
> Please attach your complete dmesg output, serial console log (with
> "ignore_loglevel"), digital photo of the error, or other specific
> details.

Ping!  If there's a problem here, I want to fix it as soon as possible.
Do you have any more details?  What error message did you google?

Thanks,
  Bjorn
