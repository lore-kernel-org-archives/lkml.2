Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727Ab0HCUem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 16:34:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56884 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757652Ab0HCUek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 16:34:40 -0400
Date: Tue, 3 Aug 2010 21:34:31 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mike Turquette <mturquette@ti.com>
Cc: "linux-pm@lists.osdl.org" <linux-pm@lists.osdl.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Power management minisummit at Linux Plumbers
	Conference (November 3-5)
Message-ID: <20100803203431.GA2969@srcf.ucam.org>
References: <20100803182746.GA32276@srcf.ucam.org> <4C587C80.3040207@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C587C80.3040207@ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 03:30:56PM -0500, Mike Turquette wrote:

> That link did not really work for me, but I think I found the right  
> place after a few clicks.

Oops! The link should have been 
http://www.linuxplumbersconf.org/2010/ocw/events/LPC2010MC/proposals .

> Just FYI, I proposed a discussion on the issues that create such a large  
> power gap between a CPUIdle-only system and a system with suspend (with  
> the assumption that the lowest C-state can be hit by both).
>
> I don't really want to present a formal lecture on it, but it would be  
> nice to discuss with the group what can be done to shrink that gap a  
> little in kernel space (badly behaving timers in platform-independent  
> code) and in userspace (power-aware timers, coalescing timers, etc).

That sounds great. The idea is to be fairly discussion-oriented, perhaps 
with a short presentation to cover the outline of the issue, so this 
kind of topic is ideal.

Thanks,
-- 
Matthew Garrett | mjg59@srcf.ucam.org
