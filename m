Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2CMRHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:07:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55160 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2CMRHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:07:15 -0400
Date: Tue, 13 Mar 2012 17:07:10 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Akio Idehara <zbe64533@gmail.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charles@schwieters.org, corentin.chary@gmail.com,
        seth.forshee@canonical.com
Subject: Re: [PATCH] toshiba_acpi: Add support for transflective LCD
Message-ID: <20120313170710.GB17110@srcf.ucam.org>
References: <4F3ECEED.9000206@gmail.com>
 <20120312141118.GB11375@srcf.ucam.org>
 <4F5F7E2F.30305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5F7E2F.30305@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 02:04:47AM +0900, Akio Idehara wrote:

> BTW, I have one question about disabling backlight interface.
> My toshiba laptop has three sysfs backlight interfaces,
> "acpi_video0", "intel_backlight" and "toshiba".
> Fedora16 is always using "acpi_video0" interface.
> If I add acpi_backlight=vendor in boot param,
> then Fedora16 uses "intel_backlight".
> # "toshiba" is lowest priority.
> So I want to know how to disable "intel_backlight" interface.
> Or enable "toshiba" interface only.

There's no general way to - the acpi interface, if present, should 
always be the preferred one. Hooking the transflective control into that 
is going to be more difficult.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
