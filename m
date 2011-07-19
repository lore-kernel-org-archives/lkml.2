Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1GSNZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:25:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59285 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab1GSNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:25:32 -0400
Date: Tue, 19 Jul 2011 15:25:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 01/34] System Firmware Interface
Message-ID: <20110719132531.GH8006@one.firstfloor.org>
References: <1310994528-26276-1-git-send-email-prarit@redhat.com> <1310994528-26276-2-git-send-email-prarit@redhat.com> <m2vcuz3xsz.fsf@firstfloor.org> <20110719100544.55c7f7fb@lxorguk.ukuu.org.uk> <4E25775A.4050306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E25775A.4050306@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Playing the devils advocate here, but this is really unclear...

> There is some additional information I'd like to throw out here as
> well.  SMBIOS also provides information on the system state after the
> BIOS/EFI is finished and before the kernel has been booted.  This has
> been *invaluable* to me when diagnosing some wonky hardware from OEMs. 

Hmm this is for SMBIOS tables that changes at runtime?
Why exactly is the kernel booting a good point to dump that?

Normally the kernel afaik doesn't change SMBIOS as far as I know.

There may be some hotplug events that change it, but they
have no particular relation to kernel boot.

> I want to expand the SMBIOS layer to dump that information out when I

What information exactly?

And dumping = print to system log?

> tl;dr: There are some other useful bits of SMBIOS we could take
> advantage of but the current "dmi" layer is difficult to work with.

Like what?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
