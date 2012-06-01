Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461Ab2FAQ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:26:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62497 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab2FAQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:26:34 -0400
Date: Fri, 1 Jun 2012 09:26:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Victor Miasnikov <vvm@tut.by>
Cc: stable@vger.kernel.org, Jonathan Nieder <jrnieder@gmail.com>,
        linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>
Subject: Re: Linux on Hyper-V 1) cd006086fa5d ata_piix: defer disks to the
 Hyper-V drivers by default 2) db63a4c8115a libata: add a host flag to ignore
 detected ATA device FW: use hv_storvsc instead of ata_piix to handle the IDE
 disks devices ( but not for the CD-R
Message-ID: <20120601162629.GA11812@kroah.com>
References: <20120527010903.GA18244@kroah.com>
 <B4A84D892D5742FE83F71F788F6EAF48@local.st.by>
 <20120528203518.GA12623@kroah.com>
 <5EBD7E368EFE4B5CABF4AC528058A4DB@local.st.by>
 <20120601092017.GE22821@kroah.com>
 <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <59CBCFF13ABD41B682835DD5E4851BC1@local.st.by>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 07:17:33PM +0300, Victor Miasnikov wrote:
> Hi!
> 
> >> cd006086fa5d ata_piix: defer disks to the Hyper-V drivers by default
> >>and its prerequisite
> >> db63a4c8115a libata: add a host flag to ignore detected ATA devices
> 
> >Sorry, but I don't see how this meets the rules for the stable trees, do you?  If so, please show me how.
> 
> About "how"  -- ask K.Y. Srinivasan
> 
> Hyper-V admins need _worked_ Linux v3.4.X / v3.3.X / v3.2.X
> 
> Please, _fix_ errors related "use hv_storvsc instead of ata_piix to
> handle the IDE disks devices ( but not for the CD-ROM)"

Ok, I'll wait for KY to explain this.

greg k-h
