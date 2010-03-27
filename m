Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0C0Bh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 21:37:28 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:51413 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0C0Bh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 21:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <1d3f23371003211532p57fe0785s5960ddea8218d4d4@mail.gmail.com>
References: <4B98F32D.8020906@monstr.eu> <fa686aa41003201035r3d95b780naf37a4725293d648@mail.gmail.com> 
	<1d3f23371003211532p57fe0785s5960ddea8218d4d4@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 26 Mar 2010 19:37:06 -0600
X-Google-Sender-Auth: d940606f8260d2c5
Message-ID: <fa686aa41003261837p3564d4e8k422cc95911f4c6a2@mail.gmail.com>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.34-rc2
To: John Williams <john.williams@petalogix.com>
Cc: monstr@monstr.eu, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 4:32 PM, John Williams
<john.williams@petalogix.com> wrote:
> Grant,
>
> On Sun, Mar 21, 2010 at 3:35 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Thu, Mar 11, 2010 at 6:42 AM, Michal Simek <monstr@monstr.eu> wrote:
>>> Hi Linus,
>>>
>>> Please pull Microblaze changes to your tree. There is support for PCI and
>>> new DMA interface.
>>>
>>> Thanks,
>>> Michal
>>
>> Hi Michal.
>>
>> I'm really unimpressed that you've merged the cloned PCI support code
>> when we talked about merging the common powerpc & microblaze bits
>> /before/ pushing it up to mainline.  At the very least I would have
>> expected a reply back from you telling me that you disagree and that
>> you wanted to merge anyway.  I didn't even get a reply back form you
>> when I asked about why the PCI bits were in your linux-next branch.
>>
>> Now it needs to be merged in-place which is a lot more work.
>
> You should blame me for this one.  There was nothing deliberate about
> it - I've been hassling Michal to get the DMA API upstream because
> there's other work that depends on it, and with everything else going
> on I plain forgot that his patchset included the PCI stuff that we
> were still discussing with you.

Blame dutifully assigned.

The next question is how to proceed.  I've not gotten to PCI code in
my rework yet, but I probably will in the next month or so.  If you or
Michal doesn't get to it first, then I'll probably move the OF
portions of the powerpc version into drivers/of and make them
conditional on !CONFIG_MICROBLAZE.  Microblaze adaptations can be
merged in at a later date and the !CONFIG_MICROBLAZE conditional
eventually dropped.

> Let me buy you a beer at ELC and you can berate me for it then!

done.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
