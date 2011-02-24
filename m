Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab1BXL3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 06:29:05 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50084 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab1BXL2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 06:28:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XzwYNrNdavqPo/7n0PuWYlDDPB2dByCVzSIceq3FrMPb2Fi2+SAIq2FxIsBar6n0Ry
         nuV5WXe5SR3fJFjCqSbFYe04wtN97lL+FxPMGzrYAogwgQBqR+sXM1aeMtVH6nyyejxm
         1t0tVHJU/TgvV466geKVvLG23lQyBo/yatW0Q=
Date: Thu, 24 Feb 2011 14:28:19 +0300
From: Dan Carpenter <error27@gmail.com>
To: Anoop P A <anoop.pa@gmail.com>
Cc: "gregkh @ suse . de" <gregkh@suse.de>,
        "dbrownell @ users . sourceforge . net" 
	<dbrownell@users.sourceforge.net>,
        "stern @ rowland . harvard . edu" <stern@rowland.harvard.edu>,
        "pkondeti @ codeaurora . org" <pkondeti@codeaurora.org>,
        "jacob . jun . pan @ intel . com" <jacob.jun.pan@intel.com>,
        "linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
        "alek . du @ intel . com" <alek.du@intel.com>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        "gadiyar @ ti . com" <gadiyar@ti.com>,
        "ralf @ linux-mips . org" <ralf@linux-mips.org>,
        "linux-mips @ linux-mips . org" <linux-mips@linux-mips.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v5] EHCI bus glue for on-chip PMC MSP USB controller
Message-ID: <20110224110138.GA28665@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Anoop P A <anoop.pa@gmail.com>,
	"gregkh @ suse . de" <gregkh@suse.de>,
	"dbrownell @ users . sourceforge . net" <dbrownell@users.sourceforge.net>,
	"stern @ rowland . harvard . edu" <stern@rowland.harvard.edu>,
	"pkondeti @ codeaurora . org" <pkondeti@codeaurora.org>,
	"jacob . jun . pan @ intel . com" <jacob.jun.pan@intel.com>,
	"linux-usb @ vger . kernel . org" <linux-usb@vger.kernel.org>,
	"alek . du @ intel . com" <alek.du@intel.com>,
	"linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
	"gadiyar @ ti . com" <gadiyar@ti.com>,
	"ralf @ linux-mips . org" <ralf@linux-mips.org>,
	"linux-mips @ linux-mips . org" <linux-mips@linux-mips.org>,
	Greg KH <greg@kroah.com>
References: <4D5ABB65.3090101@parrot.com>
 <1298388933-13707-1-git-send-email-anoop.pa@gmail.com>
 <20110222200427.GB1966@bicker>
 <1298467343.9950.119.camel@paanoop1-desktop>
 <20110223170205.GE19898@bicker>
 <1298542755.9950.277.camel@paanoop1-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298542755.9950.277.camel@paanoop1-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 03:49:15PM +0530, Anoop P A wrote:
> > Also this is dead code.  No one will complain, if you just delete it.
> You mean entire ehci_msp_suspend() ??
> 

Sure why not?  It's not really ready to submit.  People can't complain
about it if you don't submit it.

(Understand that I'm from the peanut gallery.  I'm not in anyway a 
maintainer of this code and my suggestions carry very little weight).

regards,
dan carpenter
