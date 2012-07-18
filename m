Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab2GRNYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 09:24:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:33538 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2GRNYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 09:24:44 -0400
Date: Wed, 18 Jul 2012 06:24:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "arnd@arndb.de" <arnd@arndb.de>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [char-misc-next] mei: use module_pci_driver
Message-ID: <20120718132439.GA18827@kroah.com>
References: <1342513427-10076-1-git-send-email-tomas.winkler@intel.com>
 <20120717171726.GA7538@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B13C2CD@HASMSX103.ger.corp.intel.com>
 <20120717204001.GA18021@kroah.com>
 <5B8DA87D05A7694D9FA63FD143655C1B143952@HASMSX103.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B143952@HASMSX103.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 07:42:32AM +0000, Winkler, Tomas wrote:
> > > Right, my mistake I haven't checked it directly with your tree,  I
> > > need to wait till you merge the upstream in.
> > 
> > Merge what "upstream"?
> 
> The doesn't apply    because the
>  commit a44cab4aff7e72e7052521121fd8ceca51351534
>  misc: mei: unregister misc device in pci_remove function
>     
> is only in Linus' master branch.
> 
>  Your branch char-misc-next is still at v3.5-rc2 
> I believe that in some point you'll merge the whole Linus' master
> branch into your char-misc-next branch, right?

Ah, yes, sorry, I didn't realize we needed the merge.  It's now done.

Care to resend your patch (in the proper format as discussed) so that I
can queue it up?

thanks,

greg k-h
