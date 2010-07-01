Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0GATba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 15:31:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab0GATb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 15:31:28 -0400
From: Thomas Renninger <trenn@suse.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 5/6] X86 platform drivers: Remove EC dump from thinkpad_acpi
Date: Thu, 1 Jul 2010 21:31:18 +0200
User-Agent: KMail/1.9.10
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       ibm-acpi-devel@lists.sourceforge.net
References: <1277996570-2686-1-git-send-email-trenn@suse.de> <1277996570-2686-6-git-send-email-trenn@suse.de> <20100701162741.GC4789@khazad-dum.debian.net>
In-Reply-To: <20100701162741.GC4789@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007012131.20031.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010 06:27:41 pm Henrique de Moraes Holschuh wrote:
> On Thu, 01 Jul 2010, Thomas Renninger wrote:
...
> I'd prefer if the above text gets replaced by something that adds a pointer
> to the new facility, instead of being just outright removed.  Also, the
> text about how to use the facility to detect tachometers and thermometers
> should be retained, if at all possible.
I agree. I'll repost this one in some days.

> Soes your helper userspace util do the "differential" analysis that
> thinkpad-acpi used to (the "*" after values that changed since last read)?
No.
But this should not be important enough to not get this removed.
It's hard to re-implement the exact behaviour (which can be handy for
specific problems, I agree).
With:
watch -n1 ec_access -r
you can have a close look at specific registers and see them changing.
Whatabout:
ec_access -r -s time(s)
Reads the table once and again after "time" seconds with stars
where modifications happened. Then someone can plug AC or hit a button
and look at the diff in EC registers afterwards.
This should be sufficient?
Better ideas?

Thanks,

       Thomas
