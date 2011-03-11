Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1CKToj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:44:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:54766 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1CKToh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:44:37 -0500
Date: Fri, 11 Mar 2011 19:44:22 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110311194422.GA20490@srcf.ucam.org>
References: <20110305042431.GA22840@kroah.com> <20110311174339.GJ16652@srcf.ucam.org> <20110311193512.GC14204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311193512.GC14204@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:35:12AM -0800, Greg KH wrote:
> On Fri, Mar 11, 2011 at 05:43:39PM +0000, Matthew Garrett wrote:
> > Applied, thanks.
> 
> Great, any pointers to where it was applied?  I think I need to send you
> a few more 'add a new device id' patches and I want to make sure I get
> the right version to patch against.

http://git.kernel.org/?p=linux/kernel/git/mjg59/platform-drivers-x86.git;a=shortlog;h=refs/heads/linux-next 
- ideally we'd just have it id against all Samsung laptops and check for 
SABI? Or are there machines where that might break?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
