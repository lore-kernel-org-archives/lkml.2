Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0CUWch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 18:32:37 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:43380 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0CUWcg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 18:32:36 -0400
MIME-Version: 1.0
In-Reply-To: <fa686aa41003201035r3d95b780naf37a4725293d648@mail.gmail.com>
References: <4B98F32D.8020906@monstr.eu>
	 <fa686aa41003201035r3d95b780naf37a4725293d648@mail.gmail.com>
Date: Mon, 22 Mar 2010 08:32:35 +1000
Message-ID: <1d3f23371003211532p57fe0785s5960ddea8218d4d4@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.34-rc2
From: John Williams <john.williams@petalogix.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: monstr@monstr.eu, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On Sun, Mar 21, 2010 at 3:35 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Mar 11, 2010 at 6:42 AM, Michal Simek <monstr@monstr.eu> wrote:
>> Hi Linus,
>>
>> Please pull Microblaze changes to your tree. There is support for PCI and
>> new DMA interface.
>>
>> Thanks,
>> Michal
>
> Hi Michal.
>
> I'm really unimpressed that you've merged the cloned PCI support code
> when we talked about merging the common powerpc & microblaze bits
> /before/ pushing it up to mainline.  At the very least I would have
> expected a reply back from you telling me that you disagree and that
> you wanted to merge anyway.  I didn't even get a reply back form you
> when I asked about why the PCI bits were in your linux-next branch.
>
> Now it needs to be merged in-place which is a lot more work.

You should blame me for this one.  There was nothing deliberate about
it - I've been hassling Michal to get the DMA API upstream because
there's other work that depends on it, and with everything else going
on I plain forgot that his patchset included the PCI stuff that we
were still discussing with you.

Let me buy you a beer at ELC and you can berate me for it then!

John
