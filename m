Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0DANpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 09:45:46 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:50754 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815Ab0DANpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 09:45:40 -0400
Date: Thu, 1 Apr 2010 14:45:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: commit 9630bdd9 changes behavior of the poweroff - bug?
Message-ID: <20100401134535.GA6527@srcf.ucam.org>
References: <20100401133923.GA4104@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401133923.GA4104@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 03:39:23PM +0200, Michal Hocko wrote:
> Hi Rafael, Matthew,
> my laptop changed behavior during poweroff recently (after upgrading
> from .33 to .34-rc1). The system seems to be powered off (status display
> is off) at first glance but when I close the lid then I can hear a noise
> which sounds like HDD parking and when I open lid again it starts
> booting without poweroff button (same like when I suspend to RAM).

Hm. At a guess, we're somehow managing to leave the lid GPE enabled at 
poweroff. Can you send the output of the acpidump command?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
