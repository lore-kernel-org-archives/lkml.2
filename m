Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965083Ab2CEOBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:01:38 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:35806 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964794Ab2CEOBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:01:35 -0500
Date: Mon, 5 Mar 2012 15:01:30 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>, security@kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20120305140130.GA15186@nomi.cz>
References: <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz> <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz> <1321755233.22510.1.camel@wwguy-ubuntu> <20111120032016.GA14520@nomi.cz> <1321763314.22510.4.camel@wwguy-ubuntu> <20111120204007.GA7273@nomi.cz> <20120210180929.GA17733@nomi.cz> <20120214092020.GB12905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120214092020.GB12905@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 14, 2012 at 10:20:21AM +0100, Stanislaw Gruszka wrote:
> > So it doesn't look like a memory corruption after all. It
> > seems as if certain CPU instructions didn't work properly if running on a
> > 32-bit kernel with a WiFi adapter doing something. But how can it be
> > that those same CPU instructions work on a 64-bit host with 32-bit userspace?
> > At the same time! That's just completely insane, and I can't think of an
> > explanation. Shall I get a new CPU perhaps? :-)
> >
> > 
> > Please, give me any ideas that you might have.
> 
> That make sense! Your "CPU instructions break things" theory sounds crazy,
> but I think it's logical. WPA enterprise differ from WPA-PSA (pre shared
> key) that the key changed periodically, SSL is used when keys are changed
> (via wpa_supplicant). So looks like 32-bit openssl generate object code
> that trigger bug on CPU, which crash other processes.

It seems that someone beat me to it. Since Linus fixed the FPU leaks in
3.3-rc4, I haven't experienced the problem. And I was this close! :-)

Anyway, thanks for assistance and sorry for being so slow to respond.

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
