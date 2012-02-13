Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2BMN3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 08:29:42 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:51074 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab2BMN3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 08:29:41 -0500
Date: Mon, 13 Feb 2012 14:29:37 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20120213132937.GA17203@nomi.cz>
References: <20111111150105.GA25437@nomi.cz> <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz> <1321755233.22510.1.camel@wwguy-ubuntu> <20111120032016.GA14520@nomi.cz> <1321763314.22510.4.camel@wwguy-ubuntu> <20111120204007.GA7273@nomi.cz> <20120210180929.GA17733@nomi.cz> <20120213092538.GA6214@redhat.com> <20120213130903.GA7355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120213130903.GA7355@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 13, 2012 at 02:09:04PM +0100, Stanislaw Gruszka wrote:
> I also found this bug report
> https://bugzilla.kernel.org/show_bug.cgi?id=37742
> where one user report iwlwifi corruption catched by IOMMU.

I wasn't able to catch anything using IOMMU, and I also wasn't able to
reproduce the issue using any userspace memory checking tool. Hence I tend to
believe we're not dealing with a memory corruption at all, perhaps something
like certain CPU flags/registers not being correctly saved/restored during
wlan interrupts or something. When I have a sufficient amount of free time,
I'll try to check this hypothesis and perhaps pinpoint the instruction the
result of which is corrupted during wlan operation.

> Tomáš, I do not remember, do you have the same problems on
> older kernels i.e < 3.0

Yeah. I was able to reproduce it with 2.6.38.8 and 2.6.39.4 at least.

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
