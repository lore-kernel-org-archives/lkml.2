Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0CVOun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 10:50:43 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:13407 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0CVOul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 10:50:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Otavio Salvador <otavio@ossystems.com.br>
Subject: Re: PCI conflicts with latest kernels
Date: Mon, 22 Mar 2010 07:50:37 -0700
User-Agent: KMail/1.9.10
Cc: Giampaolo Bellini <iw2lsi@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <463bccef1003140331h72b1f11qe133a6a1c952fc6d@mail.gmail.com> <201003150942.49987.bjorn.helgaas@hp.com> <be7a9f3d1003220741g48f81ebbq963f97d3fc7673d7@mail.gmail.com>
In-Reply-To: <be7a9f3d1003220741g48f81ebbq963f97d3fc7673d7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003220850.39053.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010 08:41:03 am Otavio Salvador wrote:
> Hello,
> 
> On Mon, Mar 15, 2010 at 12:42 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > [I re-added the CC: list, so the archives will have the whole
> > conversation, in case anybody else has similar problems or
> > can help answer this.]
> >
> > On Sunday 14 March 2010 05:11:55 pm Giampaolo Bellini wrote:
> >> I apply the patch but seems that it does not solve conflicts
> >
> > Yes, I didn't expect it to fix anything, only to tell us more about
> > what's happening.
> 
> Has any progress been done in this issue?
> 
> I have this same problem in VortexSX machine.

Hi Otavio,

Can you post your entire dmesg log and a description of what
problem you're seeing (e.g., device X doesn't work or whatever)?
If this is a regression, i.e., your system used to work and
now doesn't work, please tell us which version used to work
and when it broke.

Thanks,
  Bjorn

