Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1BIXDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:03:19 -0500
Received: from kroah.org ([198.145.64.141]:35021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337Ab1BIXDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:03:18 -0500
Date: Wed, 9 Feb 2011 15:02:59 -0800
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] Platform: add Samsung Laptop platform driver
Message-ID: <20110209230259.GA475@kroah.com>
References: <20110209224006.GA11202@kroah.com>
 <20110209225056.GA25009@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209225056.GA25009@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 10:50:56PM +0000, Matthew Garrett wrote:
> \o/
> 
> A quick glance suggests that the firmware interface is an abomination 
> and really there's no reason for them not to have used an existing 
> interface of some sort, but that's par for the course. I'll review it 
> properly now.

The firmware interface pre-dates ACPI.  Samsung seems to have only
started using ACPI for their newest models, as it's a requirement for
Win7 certification.  But even there, they still rely on their SABI
interface for the majority of the "odd" hardware control knobs,
including the backlight control, which baffles me even to this day.

thanks,

greg k-h
