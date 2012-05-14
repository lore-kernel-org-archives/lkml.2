Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab2ENVzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:55:38 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49382 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757704Ab2ENVzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:55:36 -0400
Date: Mon, 14 May 2012 22:55:33 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mario Limonciello <mario_limonciello@dell.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dell-laptop: rfkill blacklist Dell XPS 13z, 15z
Message-ID: <20120514215533.GA10378@srcf.ucam.org>
References: <1337023652-11661-1-git-send-email-kamal@canonical.com>
 <20120514193718.GA6438@srcf.ucam.org>
 <4FB16659.6040704@dell.com>
 <20120514211959.GA9394@srcf.ucam.org>
 <4FB1774D.4080106@dell.com>
 <20120514212842.GA9561@srcf.ucam.org>
 <4FB17DA8.1040808@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB17DA8.1040808@dell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 04:48:24PM -0500, Mario Limonciello wrote:

> The problems were exposed on newer XPS laptops because those platforms 
> were not tested during platform development.  There really isn't a 
> scalable way to represent whether a platform was or wasn't tested 
> during development.  In a lot of situation things just work.  I would 
> like to do the right thing for the users with what information and 
> resources are available right now to put them in a better state.  An 
> aggressive approach of not taking patches to cover a broken interface 
> won't fix the problem of not testing machines already in the market, 
> it will just put end users of the kernel module at a disadvantage.

That's why it's better to just remove the interface. Providing a feature 
when we know it's broken on some unknown subset of hardware doesn't 
benefit anyone. If even Dell don't have any idea which set of machines 
it works on then how are we ever expected to make sure it's correct?

> 1) Don't blacklist any Latitude or Vostro.  These are tested during platform development.
> 2) Leave those compal_laptop supported ones blacklisted.
> 3) Blacklist 2010-2012 XPS.  These are currently not tested during platform development.
> 4) If problems start to show up on Inspiron, blacklist them invidually.  These platforms are currently tested during platform development though, so hopefully issues don't crop up.

Is this the set of criteria that the Windows tools use? If so, I'll 
implement it. If not, then either provide the set of criteria that the 
Windows tools use or I'll remove the interface.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
