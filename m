Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1GFXBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 19:01:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59436 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1GFXBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 19:01:44 -0400
Date: Thu, 7 Jul 2011 00:01:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Keng-Yu Lin <kengyu@canonical.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, gmane@colin.guthr.ie,
        Alessio Igor Bogani <abogani@texware.it>, stable@kernel.org
Subject: Re: [PATCH] Revert: "dell-laptop: Toggle the unsupported hardware
 killswitch"
Message-ID: <20110706230135.GA31589@srcf.ucam.org>
References: <1309169943-3786-1-git-send-email-kengyu@canonical.com>
 <20110706155003.17090951.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706155003.17090951.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 03:50:03PM -0700, Andrew Morton wrote:
> On Mon, 27 Jun 2011 11:19:03 +0100
> Keng-Yu Lin <kengyu@canonical.com> wrote:
> 
> > This reverts commit a3d77411e8b2ad661958c1fbee65beb476ec6d70,
> > 
> > as it causes a mess in the wireless rfkill status on some models.
> > It is probably a bad idea to toggle the rfkill for all dell models
> > without the respect to the claim that it is hardware-controlled.
> > 
> 
> If we're reverting this from mainline then we should also revert it
> from 2.6.38.x and 2.6.39.x, no?

Yeah, this is stable material. I'll be dealing with the backlog 
tomorrow.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
