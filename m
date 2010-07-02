Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab0GBJOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:14:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab0GBJOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:14:05 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/6] X86 platform drivers: Remove EC dump from thinkpad_acpi
Date: Fri, 2 Jul 2010 11:14:00 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       ibm-acpi-devel@lists.sourceforge.net
References: <1277996570-2686-1-git-send-email-trenn@suse.de> <20100701162741.GC4789@khazad-dum.debian.net> <201007012131.20031.trenn@suse.de>
In-Reply-To: <201007012131.20031.trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007021114.00982.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010 21:31:18 Thomas Renninger wrote:
> On Thursday 01 July 2010 06:27:41 pm Henrique de Moraes Holschuh wrote:
> > On Thu, 01 Jul 2010, Thomas Renninger wrote:
> ...
> > I'd prefer if the above text gets replaced by something that adds a pointer
> > to the new facility, instead of being just outright removed.  Also, the
> > text about how to use the facility to detect tachometers and thermometers
> > should be retained, if at all possible.
> I agree. I'll repost this one in some days.
Hmm, I take that back.
This still should get removed completely from:
Documentation/laptops/thinkpad-acpi.txt

These problems apply to all laptops and instead of adding pointers to all
Documentation/laptop/${vendor} files,
a separate file should be added. This should then be more about thermal
management problems in general and pointers to:
Documentation/acpi/ec_sysfs
and
Documentation/acpi/debug.txt
Documentation/acpi/*
added there looks like the appropriate solution to me.

If people agree:
  - This patch is still fine and should get applied as it is
  - I will send another patch adding some more documentation
    in some days

Thanks,

    Thomas
