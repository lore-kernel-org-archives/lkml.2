Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158Ab1BKU4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:56:38 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39503 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab1BKU4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:56:37 -0500
Date: Fri, 11 Feb 2011 20:56:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ayan George <ayan.george@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dell-laptop: add Dell Vostro 1520 to blacklist.
Message-ID: <20110211205632.GA12887@srcf.ucam.org>
References: <4D55A07A.7050608@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D55A07A.7050608@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 03:47:54PM -0500, Ayan George wrote:
> The dell-laptop module erroneously hard-blocks the wireless interface on
> the Dell Vostro 1520.
> 
> All functionality (backlight, volume, physical wireless switch, &c)
> is there without the dell-laptop module so this blacklists the
> Dell Vostro 1520.
> 
> BugLink: http://bugs.launchpad.net/bugs/701259
> Signed-off-by: Ayan George <ayan.george@canonical.com>
> Cc: <stable@kernel.org>

I'd like to try to work out what's actually going on here first. Do we 
have any feedback from Dell on whether this is expected to work?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
