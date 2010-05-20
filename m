Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0ETNcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 09:32:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38303 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab0ETNcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 09:32:51 -0400
Date: Thu, 20 May 2010 14:32:37 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joey Lee <jlee@novell.com>
Cc: dmitry.torokhov@gmail.com, gregkh@suse.de, mzxreary@0pointer.de,
       greg@kroah.com, rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state with
	BIOS when function key pressed
Message-ID: <20100520133237.GC15356@srcf.ucam.org>
References: <4BEE602B020000230001928D@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEE602B020000230001928D@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joey,

This patch didn't apply cleanly, but I've fixed it up by hand. I've also 
applied the rest of the patchset.

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
