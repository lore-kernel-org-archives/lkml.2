Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0EMXjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:39:49 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48084 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab0EMXjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:39:47 -0400
Date: Fri, 14 May 2010 00:39:36 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, lenb@kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
Message-ID: <20100513233936.GA22338@srcf.ucam.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <20100513181002.GB23708@core.coreip.homeip.net> <alpine.LFD.2.00.1005131232350.3711@i5.linux-foundation.org> <201005131405.45732.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005131405.45732.dmitry.torokhov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 02:05:44PM -0700, Dmitry Torokhov wrote:

> But I guess because there are no devices plugged in ACPI they are "inactive" 
> and thus ACPI drop them. I was always wondered by ACPI did that. Len?

Yeah, if _STA gives you 0 then the device won't be visible. That may not 
be optimal in this case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
