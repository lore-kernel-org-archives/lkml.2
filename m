Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202Ab2FBShf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 14:37:35 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:39806 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933600Ab2FBShe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 14:37:34 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjNKALBcyk9V5qg+PGdsb2JhbABFigmqFRkBAQEBHhkNJ4IYAQEEATocIwULCAMOOBQlChqIGQm2GBSQLWADlRqFYIx5
X-IronPort-AV: E=Sophos;i="4.75,703,1330902000"; 
   d="scan'208";a="350727568"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 2 Jun 2012 20:38:27 +0200
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jordan Justen <jordan.l.justen@intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [GIT PULL] x86/efi changes for v3.5
Message-ID: <20120602183827.GA4020@polaris.bitmath.org>
References: <20120523075433.GA12526@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523075433.GA12526@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Hans Peter, Matt, Jordan,

> This patchset makes changes to the bzImage EFI header, so that 
> it can be signed with a secure boot signature tool. It should 
> not affect anyone who is not using the EFI self-boot feature in 
> any way.

Commit 2e064b1 (Fix issue of overlapping .reloc section for EFI_STUB)
breaks EFI boot on my MacBookAir3,1. The efi firmware no longer
recognizes the bzImage and falls back to BIOS emulation boot.

Reverting 2e064b1 works for me, but I am happy to test other options
as well.

Thanks,
Henrik
