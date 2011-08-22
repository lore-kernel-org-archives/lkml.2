Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab1HVTmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 15:42:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58828 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab1HVTmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 15:42:07 -0400
Date: Mon, 22 Aug 2011 20:42:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] i915: do not setup intel_backlight twice
Message-ID: <20110822194204.GA6361@srcf.ucam.org>
References: <20110817141010.GA21479@redhat.com>
 <1314041950-12433-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314041950-12433-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 12:39:10PM -0700, Kamal Mostafa wrote:
> The commit "Not all systems expose a firmware or platform mechanism for
> changing the backlight intensity on i915, so add native driver support"
> adds calls to  intel_panel_setup_backlight() from intel_{lvds,dp}_init
> so do not call it again from intel_setup_outputs().
> 
> BugLink: http://bugs.launchpad.net/bugs/831542
> 
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>

ACKed-by: Matthew Garrett <mjg@redhat.com>

-- 
Matthew Garrett | mjg59@srcf.ucam.org
