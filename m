Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab1BKS5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:57:18 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55045 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab1BKS5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eI82re65qRriCBacHZdf4n0iFZuh8Kkt4nZyOz0lrb/VSStQZviug+h8kbpxwUpy1S
         4xZl8gsyhFjs3Xs29gVpvBdV/cifvN+gLEKhXbfTyyqHZVlep5oPZTpftsB5xjbH9n/s
         nz5wZBc/ceK2O+rOndoO4qdpMC1HHjF+H5d1Y=
Date: Fri, 11 Feb 2011 10:57:10 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: ycwang <yenchengwang@gmail.com>, dbrownell@users.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: fixed a macro coding style
 issue
Message-ID: <20110211185710.GB31385@core.coreip.homeip.net>
References: <1297438592-8566-1-git-send-email-yenchengwang@gmail.com>
 <20110211173918.GA9176@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211173918.GA9176@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 09:39:18AM -0800, Greg KH wrote:
> On Fri, Feb 11, 2011 at 11:36:32PM +0800, ycwang wrote:
> > Fixed a macro coding style issue.
> 
> What macro coding style issue did you fix?  Please be more specific and
> resend the patch with a more complete changelog entry.
> 

It is simply incorrect as it adds do {} while (0) to the module
parameter constructors which are used outside of functions.

The change was never compiled.

-- 
Dmitry
