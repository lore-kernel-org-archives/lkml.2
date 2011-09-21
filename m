Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab1IUPbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:31:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53820 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab1IUPbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:31:40 -0400
Date: Wed, 21 Sep 2011 16:31:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] toshiba_acpi: Cleanup and TOS1900 device support
Message-ID: <20110921153137.GA26436@srcf.ucam.org>
References: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316555754-25949-1-git-send-email-seth.forshee@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 04:55:48PM -0500, Seth Forshee wrote:
> Hi Matthew,
> 
> Please consider merging the following patches. They represent a
> signficant cleanup of toshiba_acpi as well as adding support for SPFC as
> an HCI method. The latter provides basic but functional support for the
> TOS1900 devices found on newer Toshiba models, which will serve as a
> good starting point for further enhancements. I've tried to leave the
> details of the hardware interaction unchanged to reduce the risk of
> regression for machines already supported by the driver.

Great. Has this been tested on any older hardware? I'd think that the 
risk of regression is pretty low, but it'd be a nice sanity check. I've 
only got one TOS1800 type around here, and it's a 1.2GHz Pentium M, so 
I'd prefer to have got someone else to do it :)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
