Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1AKQsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:48:45 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52248 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab1AKQsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:48:43 -0500
Date: Tue, 11 Jan 2011 16:48:34 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mourad De Clerck <mourad@aquazul.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
        Richard Hughes <richard@hughsie.com>
Subject: Re: mbp_nvidia_bl: Remove DMI dependency (was: Re: [PATCH,RESEND]
	backlight: mbp_nvidia_bl - add support for MacBookPro7,1)
Message-ID: <20110111164834.GA28175@srcf.ucam.org>
References: <4D145EB5.7090205@aquazul.com> <20110104143651.8f6d62e0.akpm@linux-foundation.org> <4D2C8864.8030909@aquazul.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2C8864.8030909@aquazul.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 05:42:12PM +0100, Mourad De Clerck wrote:
> A bit late, but I tested this patch series and it works for me.
> 
> The only slight change is that gnome-power-manager needs to be updated
> to use /sys/class/backlight/apple_backlight instead of mbp_backlight.

gnome-power-manager needs not to have a hardcoded list of backlights. 
Richard?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
