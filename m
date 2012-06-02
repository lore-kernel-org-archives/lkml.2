Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748Ab2FBBWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 21:22:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45173 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317Ab2FBBWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 21:22:54 -0400
Date: Fri, 1 Jun 2012 18:22:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Victor Miasnikov <vvm@tut.by>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the
 Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore
 detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE
 disks devices ( but not for the ...
Message-ID: <20120602012249.GA7783@kroah.com>
References: <20120527010903.GA18244@kroah.com>
 <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
 <20120528203518.GA12623@kroah.com>
 <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by>
 <20120601092017.GE22821@kroah.com>
 <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
 <20120601162629.GA11812@kroah.com>
 <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF90710C295@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 07:23:00PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, June 01, 2012 12:26 PM
> > To: Victor Miasnikov
> > Cc: stable@vger.kernel.org; Jonathan Nieder; linux-kernel@vger.kernel.org; KY
> > Srinivasan
> > Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the Hyper-
> > V drivers by default 2) db63a4c8115a libata: add a host flag to ignore detected
> > ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE disks devices
> > ( but not for the ...
> > 
> > On Fri, Jun 01, 2012 at 07:17:33PM +0300, Victor Miasnikov wrote:
> > > Hi!
> > >
> > > >> cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default
> > > >>and its prerequisite
> > > >> db63a4c8115a libata: add a host flag to ignore detected ATA devices
> > >
> > > >Sorry, but I don't see how this meets the rules for the stable trees, do you?  If
> > so, please show me how.
> > >
> > > About "how"  -- ask K.Y. Srinivasan
> > >
> > > Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
> > >
> > > Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
> > > handle the IDE disks devices ( but not for the CD-ROM)"
> > 
> > Ok, I'll wait for KY to explain this.
> 
> Greg,
> 
> Clearly I cannot tell you anything about this that you don't know! Looking at the 
> rules for stable tree patches, this patch does not satisfy the requirement that
> the patch fix a bug since we are changing the behavior here of the ata driver to
> accommodate Hyper-V. I don't know how much flexibility you have here for
> taking patches that improve the general usability of Linux in different
> environments. All I can say is that It will be nice to have this patch in previous stable 
> releases.

Lots of things would be "nice", but as this doesn't meet the
stable_kernel_rules.txt rules, sorry, I can't take them.

greg k-h
