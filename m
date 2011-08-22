Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab1HVJyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:54:09 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:58731 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1HVJyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:54:03 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org>
	<CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com>
Date: Mon, 22 Aug 2011 17:54:00 +0800
Message-ID: <CAM_iQpWH=euPRVbcSH+L0p0sv2Cck6oazreaSjR5FS7x74iXRg@mail.gmail.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 6:28 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Fri, Aug 19, 2011 at 7:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> From: Andi Kleen <ak@linux.intel.com>
>>
>> Reposting due to popular demand. Several other people are running
>> into the same problem with all kinds of software.
>>
>> Only change is rebase against current master.
>>
> FWIW, couldn't this be made a boot option ?

A boot parameter to change kernel version sounds odd.

>
> That might help some distros, say Fedora, who actually ships
> 2.6.40+x-branded kernels, or allow people to use no longer supported
> distros with recent kernels.
>
> About this last point, once functional, I intend to upgrade my trixbox
> install (based on 2.6.18) to a 3.x-ish kernel, that might be fun...
>

Then a Kconfig option would help.
