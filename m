Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2ENThX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:37:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35087 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab2ENThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:37:21 -0400
Date: Mon, 14 May 2012 20:37:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
Message-ID: <20120514193718.GA6438@srcf.ucam.org>
References: <1337023652-11661-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337023652-11661-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 12:27:32PM -0700, Kamal Mostafa wrote:
> From: Mario Limonciello <mario_limonciello@dell.com>
> 
> On Dell XPS 13z (L321X) and 15z (L502X), switching off Bluetooth also
> disables wifi due to improper improper BIOS interaction with dell-laptop.
> Add those models to the rfkill blacklist.

What does "Improper BIOS interaction" mean? What's the proper BIOS 
interaction?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
