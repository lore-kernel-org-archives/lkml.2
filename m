Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0LQAE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:04:29 -0500
Received: from kroah.org ([198.145.64.141]:53533 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab0LQAE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:04:27 -0500
Date: Thu, 16 Dec 2010 16:02:02 -0800
From: Greg KH <greg@kroah.com>
To: Jef Driesen <jefdriesen@telenet.be>
Cc: Robert Lukassen <Robert.Lukassen@tomtom.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: g_serial: Allow to override the default VID/PID
Message-ID: <20101217000202.GA29844@kroah.com>
References: <4CE6F807.1090607@telenet.be>
 <1290209554-7026-1-git-send-email-jefdriesen@telenet.be>
 <20101120001247.GB17421@kroah.com>
 <4CE853BF.80504@telenet.be>
 <D6DB9C7EDECDA944B870F62B587008622C8A42@NL-EXC-06.intra.local>
 <20101130174605.GC19977@kroah.com>
 <4CF96A9D.8070800@telenet.be>
 <D6DB9C7EDECDA944B870F62B587008622C8A4D@NL-EXC-06.intra.local>
 <4D0874FB.8080503@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0874FB.8080503@telenet.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 08:57:47AM +0100, Jef Driesen wrote:
> On 06/12/10 09:09, Robert Lukassen wrote:
> >Yes, providing access to those module parameters was the original goal. I
> >agree that my patch should be reverted and I'll try to come up with a method
> >of accessing these values without violating the information hiding principles
> >too much. I don't like accessing globals.
> 
> Do I have to take any action to make sure the original commit [1] gets reverted?
> 
> [1] 1ab83238740ff1e1773d5c13ecac43c60cf4aec4

It's now reverted.

thanks,

greg k-h
