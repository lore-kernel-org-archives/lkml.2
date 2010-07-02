Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987Ab0GBP66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:58:58 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53591 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758896Ab0GBP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:58:56 -0400
X-Sasl-enc: dxOjI2aQ17jsvGYjSgWoFyTFNnUKm+1jVmoGJcEX4RhB 1278086335
Date: Fri, 2 Jul 2010 12:58:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH 5/6] X86 platform drivers: Remove EC dump from
 thinkpad_acpi
Message-ID: <20100702155852.GA11697@khazad-dum.debian.net>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
 <20100701162741.GC4789@khazad-dum.debian.net>
 <201007012131.20031.trenn@suse.de>
 <201007021114.00982.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007021114.00982.trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Jul 2010, Thomas Renninger wrote:
> On Thursday 01 July 2010 21:31:18 Thomas Renninger wrote:
> > On Thursday 01 July 2010 06:27:41 pm Henrique de Moraes Holschuh wrote:
> > > On Thu, 01 Jul 2010, Thomas Renninger wrote:
> > ...
> > > I'd prefer if the above text gets replaced by something that adds a pointer
> > > to the new facility, instead of being just outright removed.  Also, the
> > > text about how to use the facility to detect tachometers and thermometers
> > > should be retained, if at all possible.
> > I agree. I'll repost this one in some days.
> Hmm, I take that back.
> This still should get removed completely from:
> Documentation/laptops/thinkpad-acpi.txt
> 
> These problems apply to all laptops and instead of adding pointers to all
> Documentation/laptop/${vendor} files,
> a separate file should be added. This should then be more about thermal
> management problems in general and pointers to:
> Documentation/acpi/ec_sysfs
> and
> Documentation/acpi/debug.txt
> Documentation/acpi/*
> added there looks like the appropriate solution to me.

And a pointer to the new docs added to thinkpad-acpi.txt in place of the
text you're removing, please.

> If people agree:
>   - This patch is still fine and should get applied as it is
>   - I will send another patch adding some more documentation
>     in some days

I'm ok with this, as long as you add a pointer in thinkpad-acpi.txt to the
new docs in the future documentation patch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
