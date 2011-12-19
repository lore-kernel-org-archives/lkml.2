Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1LSJNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:13:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64328 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab1LSJNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:13:08 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.242.107]
In-Reply-To: <477F20668A386D41ADCC57781B1F704308185E330B@SC-VEXCH1.marvell.com>
References: <20111205125416.6093ecd8@notabene.brown> <CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
 <20111206060654.0e8bebe0@notabene.brown> <CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
 <20111210181546.6da7099a@notabene.brown> <CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F704308185E330B@SC-VEXCH1.marvell.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 19 Dec 2011 11:12:47 +0200
Message-ID: <CAK=Wgbb9nnC8e8aLS3XwLfHi8N2bXFSMYeviAOE9LOeocAPckQ@mail.gmail.com>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until
 probe is finished.
To: Bing Zhao <bzhao@marvell.com>
Cc: NeilBrown <neilb@suse.de>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@laptop.org>,
        Joe Woodward <jw@terrafix.co.uk>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bing,

On Thu, Dec 15, 2011 at 9:35 AM, Bing Zhao <bzhao@marvell.com> wrote:
>> I wonder why the sdio reset command isn't helpful for you - it did
>> seem to resolve some issues for Daniel. Maybe you have two different
>> hardware revisions of the 8686 which behave differently in this
>> respect ?
>
> CMD52 Card Reset (writing bit3=1 to CCCR 0x06) may not reset the SD8686 properly for some systems. The reliable way to reset SD8686 is via RESETn toggling.

Thanks a lot for confirming this.

Ohad.
