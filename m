Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414Ab1IUPfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:35:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38312 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab1IUPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:35:08 -0400
Date: Wed, 21 Sep 2011 16:35:07 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Azael Avalos <coproscefalo@gmail.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] toshiba_acpi: Convert to use acpi_driver
Message-ID: <20110921153507.GB26436@srcf.ucam.org>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
 <1316555754-25949-2-git-send-email-seth.forshee@canonical.com>
 <CAHR064iA1877cF1rmUhX_41U_yjRGs6siswpoMPjs=WEYEm8cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064iA1877cF1rmUhX_41U_yjRGs6siswpoMPjs=WEYEm8cQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 09:28:30AM +0200, Corentin Chary wrote:
> On Tue, Sep 20, 2011 at 11:55 PM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > Changes toshiba_acpi to register an acpi driver and eliminates the
> > platform device it was using.
> 
> Why to you want to remove the platform device ? If you want to create
> a sysfs interface later, you'll probably need it. Most of the platform
> driver I know only use the acpi_device to send proc/netlink events and
> the platform_device is used everywhere else. (And anyway, it's an x86
> *platform* driver, not a pure acpi driver).

There's no hard requirement for a platform device, and given that it's 
purely using ACPI methods it arguably *is* a pure ACPI driver - Toshiba 
could use the same interface on an ARM device, if they were feeling 
excessively enthusiastic. But I've no strong feelings either way.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
