Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab0CTRf5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:35:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60240 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab0CTRf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <4B98F32D.8020906@monstr.eu>
References: <4B98F32D.8020906@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 20 Mar 2010 11:35:36 -0600
X-Google-Sender-Auth: 031006a9ebf7da82
Message-ID: <fa686aa41003201035r3d95b780naf37a4725293d648@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.34-rc2
To: monstr@monstr.eu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 6:42 AM, Michal Simek <monstr@monstr.eu> wrote:
> Hi Linus,
>
> Please pull Microblaze changes to your tree. There is support for PCI and
> new DMA interface.
>
> Thanks,
> Michal

Hi Michal.

I'm really unimpressed that you've merged the cloned PCI support code
when we talked about merging the common powerpc & microblaze bits
/before/ pushing it up to mainline.  At the very least I would have
expected a reply back from you telling me that you disagree and that
you wanted to merge anyway.  I didn't even get a reply back form you
when I asked about why the PCI bits were in your linux-next branch.

Now it needs to be merged in-place which is a lot more work.

g.
