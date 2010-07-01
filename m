Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab0GAX0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:26:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:35726 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab0GAX0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:26:08 -0400
X-Sasl-enc: x94K2QwWYEC16Ye7s/6k5XxLe3Vrv5WzccMbnJ5DWB31 1278026767
Date: Thu, 1 Jul 2010 20:26:03 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       ibm-acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH 5/6] X86 platform drivers: Remove EC dump from
 thinkpad_acpi
Message-ID: <20100701232603.GA15824@khazad-dum.debian.net>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
 <1277996570-2686-6-git-send-email-trenn@suse.de>
 <20100701162741.GC4789@khazad-dum.debian.net>
 <201007012131.20031.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201007012131.20031.trenn@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jul 2010, Thomas Renninger wrote:
> > Soes your helper userspace util do the "differential" analysis that
> > thinkpad-acpi used to (the "*" after values that changed since last read)?
> No.
> But this should not be important enough to not get this removed.

Consider it a feature request ;-)

> It's hard to re-implement the exact behaviour (which can be handy for
> specific problems, I agree).
> With:
> watch -n1 ec_access -r
> you can have a close look at specific registers and see them changing.
> Whatabout:
> ec_access -r -s time(s)
> Reads the table once and again after "time" seconds with stars
> where modifications happened. Then someone can plug AC or hit a button
> and look at the diff in EC registers afterwards.
> This should be sufficient?

Yes.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
