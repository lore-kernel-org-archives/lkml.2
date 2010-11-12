Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0KLDoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 22:44:30 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:44485 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab0KLDo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 22:44:29 -0500
Date: Fri, 12 Nov 2010 03:44:23 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Norbert Preining <preining@logic.at>
Cc: Mattia Dongili <malattia@linux.it>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101112034423.GA7407@srcf.ucam.org>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111235000.GA6651@gamma.logic.tuwien.ac.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 08:50:00AM +0900, Norbert Preining wrote:
> On Mi, 10 Nov 2010, Mattia Dongili wrote:
> > It's ages sony_laptop doesn't change, it may be some other change in the
> > acpi layer that causes this.
> 
> Seems so that the sys files have changed to new locations:
> /sys/devices/virtual/backlight/acpi_video0/brightness
> 
> (mind the additional "virtual")
> as well as thermal zone etc etc.
> 
> Could that explain the problem?

Only if you have some wonderfully badly written software. What are you 
using to control the backlight? Also, I'd note that in this case your 
backlight is controlled via ACPI, not sony-laptop.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
