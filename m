Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab1CKTzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:55:19 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47015 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1CKTzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:55:14 -0500
Date: Fri, 11 Mar 2011 19:55:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110311195500.GA20784@srcf.ucam.org>
References: <20110305042431.GA22840@kroah.com> <20110311174339.GJ16652@srcf.ucam.org> <20110311193512.GC14204@kroah.com> <20110311194422.GA20490@srcf.ucam.org> <20110311195221.GA14719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110311195221.GA14719@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 11:52:21AM -0800, Greg KH wrote:

> I wouldn't mind just doing a DMI match on all Samsung laptops, it would
> save me having to constantly send patch updates, so I'll let this be
> your call :)

I think it'd be worth a go, at least. dell-laptop has example alias 
lines for that, there's a few different DMI classes that can be used for 
laptops so you'd need to check which one Samsung are using.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
