Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2ACWUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:20:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35963 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab2ACWT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:19:58 -0500
Date: Tue, 3 Jan 2012 22:19:54 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, Bdale Garbee <bdale@gag.com>
Subject: Re: [PATCH] acpi/video: Don't restore backlight to 0 at boot time
Message-ID: <20120103221954.GA2313@srcf.ucam.org>
References: <1325321547-20637-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325321547-20637-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI arguably does define 0 as being off (this is exceedingly poorly 
defined), but I'm not entirely happy with this - the firmware makes its 
behaviour conditional on the OS version. I'd really like to see an 
updated version of the Intel opregion spec to get a better idea of what 
we're meant to be doing here, but the last one made public was ancient.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
