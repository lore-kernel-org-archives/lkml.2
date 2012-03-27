Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2C0QJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:09:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:37207 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2C0QJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:09:09 -0400
Date: Tue, 27 Mar 2012 17:09:07 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmi, Use little-endian for sysfs PRODUCT UUID
Message-ID: <20120327160907.GB8398@srcf.ucam.org>
References: <1332785571-1475-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332785571-1475-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 02:12:51PM -0400, Prarit Bhargava wrote:
> Although RFC 4122 recommends network byte order for all fields, the PC
> industry (including the ACPI, UEFI, and Microsoft specifications) has
> consistently used little-endian byte encoding for the first three
> fields: time_low, time_mid, time_hi_and_version. The same encoding, also
> known as wire format, should also be used for the SMBIOS representation of
> the UUID.

There's some potential for breakage here. Perhaps add an additional 
attribute that adds the purely little-endian UUID?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
