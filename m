Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab0FOPdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 11:33:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34589 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0FOPdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 11:33:02 -0400
Date: Tue, 15 Jun 2010 16:32:56 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] pci: Don't enable aspm before drivers have had a
	chance to veto it
Message-ID: <20100615153256.GA20309@srcf.ucam.org>
References: <1276113907-22432-1-git-send-email-mjg@redhat.com> <4C17983F.8020405@redhat.com> <20100615151849.GA19895@srcf.ucam.org> <4C179C3E.6000702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C179C3E.6000702@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 05:29:02PM +0200, Tomas Henzl wrote:
> On 06/15/2010 05:18 PM, Matthew Garrett wrote:
> > On Tue, Jun 15, 2010 at 05:11:59PM +0200, Tomas Henzl wrote:
> >
> >   
> >> Matthew, isn't it so that the POLICY_DEFAULT will pass the above test
> >> and possibly switch the ASPM on?
> >>     
> > Yes. We assume that the BIOS authors aren't actively malicious.
> >   
> I originally thought your patch is about not enabling ASPM on broken 
> hardware (bios included) before the driver has a chance to change it.

Heh. No, if the BIOS set up ASPM on the controller, it seems like it's 
safe to do the same. That's been the default behaviour of upstream for 
some time now.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
