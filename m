Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2BVIyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:54:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44622 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2BVIyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:54:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLENnvYn+xkDufQeTcgbKBsrrf=hw=g_ejCrts7ZNPa-Cg@mail.gmail.com>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	<CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	<20120126232555.GB16330@gamma.logic.tuwien.ac.at>
	<20120127015015.GA23291@gamma.logic.tuwien.ac.at>
	<CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
	<20120222003747.GA9808@gamma.logic.tuwien.ac.at>
	<CAOJsxLENnvYn+xkDufQeTcgbKBsrrf=hw=g_ejCrts7ZNPa-Cg@mail.gmail.com>
Date: Wed, 22 Feb 2012 10:54:20 +0200
Message-ID: <CANUX_P3f-9-1pnCRcLmTdt0irjA_JfkXoWrHQD_NtfDemXPoYQ@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please check this one:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=3d29dd9b5b160ba4542a9b8f869a220559e633a0

it is in 3.3-rc4


On Wed, Feb 22, 2012 at 10:40, Pekka Enberg <penberg@kernel.org> wrote:
> On Wed, Feb 22, 2012 at 2:37 AM, Norbert Preining <preining@logic.at> wrote:
>> I still see that, on 3.3-rc4, and it is the same as usual. The interface
>> believes it is up and connected, but nothing works.
>>
>> I am *100%* sure that this is related to the driver, because in old
>> revisions (somewhen around 2.6.27 or so) it was working without
>> any problem, and when it started I reported it long time ago.
>
> It's definitely a kernel regression, no question about it. Was 3.3-rc1
> already broken for you? It shouldn't be that difficult to find the
> offending commit with git bisect if it's that easy to reproduce for
> you.
>
>                        Pekka
