Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab2ENVUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:20:04 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56229 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab2ENVUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:20:02 -0400
Date: Mon, 14 May 2012 22:19:59 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
Message-ID: <20120514211959.GA9394@srcf.ucam.org>
References: <1337023652-11661-1-git-send-email-kamal@canonical.com>
 <20120514193718.GA6438@srcf.ucam.org>
 <4FB16659.6040704@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB16659.6040704@dell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 03:08:57PM -0500, Mario Limonciello wrote:
> 
> On 05/14/2012 02:37 PM, Matthew Garrett wrote:
> >What does "Improper BIOS interaction" mean? What's the proper BIOS interaction?
> These platforms are not obeying the smbios interface specs for turning on and off radios.  It's not currently expected that the interaction will improve during the lifetime of these platforms.  If it does, then this can be adjusted to only apply to the BIOS versions before the fix.

Ok, pretty bored of this at this point. If the bios interface is 
unreliable then I'll just remove the rfkill support. I'm not going to 
continue adding machines to a blacklist some time after users find 
things are broken.

Is this just as broken under Windows?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
