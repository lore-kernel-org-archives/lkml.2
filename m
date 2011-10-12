Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1JLW17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:27:59 -0400
Received: from claw.goop.org ([74.207.240.146]:46809 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab1JLW16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:27:58 -0400
Message-ID: <4E96146C.5070701@goop.org>
Date: Wed, 12 Oct 2011 15:27:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1317060617.git.jeremy.fitzhardinge@citrix.com> <4E94E1E5.4070505@goop.org> <20111012101615.GA14966@aftab> <4E95D9E7.6090304@zytor.com> <4E95E7FE.6050302@goop.org> <20111012194543.GD14966@aftab>
In-Reply-To: <20111012194543.GD14966@aftab>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2011 12:45 PM, Borislav Petkov wrote:
> On Wed, Oct 12, 2011 at 03:18:22PM -0400, Jeremy Fitzhardinge wrote:
>> While doing the whole boot time multiboot thing may offer some small
>> hypothetical technical advantages, it has the significant cost of just
>> complicating the whole deployment and use story.
> You simply can't call the need to apply ucode as early as possible a
> "hypothetical techical advantage."

The current scheme has worked pretty well so far; there doesn't seem to
be a huge concern about it.  Have there been actual observed failures
with the current mechanism, or is the drive to make it earlier driven by
an aesthetic desire to make it "as it should be"?

>  Other issues like how to handle ucode
> images and how to put them together and how distros distribute them
> and whether xen minimizes the amount of "specialness" or not are only
> secondary.

No, they're not.  If users end up with a broken setup then they get no
microcode updates at all, which makes everything else moot.  It has to
be deployed correctly for it to be worth anything at all.

What is secondary, or rather, completely irrelevant is whether Xen is
involved or not.

    J
