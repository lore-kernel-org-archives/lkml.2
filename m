Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1LQLKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 06:10:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54473 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1LQLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 06:10:46 -0500
MIME-Version: 1.0
In-Reply-To: <86d3cc5f1d.fsf@sumi.keithp.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com>
	<861usye0og.fsf@sumi.keithp.com>
	<CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com>
	<86sjlccchg.fsf@sumi.keithp.com>
	<CAGPN=9SLsESVPdwhBwJN9G+nkENcFDqhrcva8GC-VTnx_E=apg@mail.gmail.com>
	<86pqge96z1.fsf@sumi.keithp.com>
	<CAGPN=9RZgCJy9hF4RqY1BLmC7cA7QWavWfRM26U3czWZ6RBNMQ@mail.gmail.com>
	<CAGPN=9Tk69_-oNZpabY+9pWnjdLR=AdMY1N7s9iCkRsonCsotQ@mail.gmail.com>
	<86d3cc5f1d.fsf@sumi.keithp.com>
Date: Sat, 17 Dec 2011 12:10:45 +0100
Message-ID: <CAGPN=9Sesv8GMgj1rbvqDsns6=O-Nao4=mZ72QYu+4-SiY9OmA@mail.gmail.com>
Subject: Re: i915: 3.2 rc1/2 KMS regression
From: Patrik Kullman <patrik.kullman@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has been solved with commit
ed4a51842a9d9e618d4f4c31349b15b974dba5df in 3.2-rc6.

Thank you.

2011/11/28 Keith Packard <keithp@keithp.com>:
> On Mon, 28 Nov 2011 11:28:53 +0100, Patrik Kullman <patrik.kullman@gmail.com> wrote:
>> Ok, so attached are:
>>
>> 3.1.rc6+.dmesg: dmesg from last working commit (before
>> dc22ee6fc18ce0f15424e753e8473c306ece95c1) booted with drm.debug=4
>>
>> 3.2.rc3+.dmesg: dmesg from 3.2 rc3 with
>> dc22ee6fc18ce0f15424e753e8473c306ece95c1 reverted, booted with
>> drm.debug=4
>
> Thanks. I'm heading to London shortly, but I'll take a look at these
> when I've got a few minutes to spare.
>
> --
> keith.packard@intel.com
