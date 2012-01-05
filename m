Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab2AETej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:34:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:53470 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151Ab2AETeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:34:37 -0500
Date: Thu, 5 Jan 2012 19:34:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>, Azael Avalos <coproscefalo@gmail.com>,
        Thomas Renninger <trenn@suse.de>, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] toshiba_acpi: Add blacklist for models with
 hotkey problems
Message-ID: <20120105193431.GA26097@srcf.ucam.org>
References: <1325617358-8286-1-git-send-email-seth.forshee@canonical.com>
 <1325617358-8286-5-git-send-email-seth.forshee@canonical.com>
 <20120105182627.GE24242@srcf.ucam.org>
 <20120105193228.GB25386@ubuntu-macmini>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120105193228.GB25386@ubuntu-macmini>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 05, 2012 at 01:32:28PM -0600, Seth Forshee wrote:

> Also a side note of interest: The machines that suffer from this all
> also have a WMI interface with code to support hotkeys, and that code
> shouldn't suffer from this problem. Unfortunately these models are the
> only ones I've seen with this WMI interface, and the code to generate
> the hotkey events isn't executed if the OS reports itself as Vista or
> newer.

In that case, can you check for the presence of the WMI interface and 
then refuse to bind? That's seem far simpler than adding an unknown 
number of systems to the blacklist.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
