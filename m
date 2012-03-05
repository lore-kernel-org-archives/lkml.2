Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab2CEPSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:18:12 -0500
Received: from ackle.nomi.cz ([81.31.33.35]:41173 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab2CEPSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:18:10 -0500
Date: Mon, 5 Mar 2012 16:18:08 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>, security@kernel.org
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20120305151808.GA24309@nomi.cz>
References: <1321755233.22510.1.camel@wwguy-ubuntu> <20111120032016.GA14520@nomi.cz> <1321763314.22510.4.camel@wwguy-ubuntu> <20111120204007.GA7273@nomi.cz> <20120210180929.GA17733@nomi.cz> <20120214092020.GB12905@redhat.com> <20120305140130.GA15186@nomi.cz> <20120305145700.GA17800@redhat.com> <20120305150031.GA22387@nomi.cz> <20120305151138.GB17800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120305151138.GB17800@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Mar 05, 2012 at 04:11:41PM +0100, Stanislaw Gruszka wrote:
> Perhaps bug was triggered because KVM 32-bit guest had CONFIG_CRYPTO_AES_NI_INTEL
> enabled ?

Nope. CONFIG_CRYPTO_AES_NI_INTEL is enabled only in the 64-bit host kernel.
Guest kernel version is 2.6.32-220.2.1.el6.i686 and there's no mention of
AES_NI_INTEL in its .config.

(And I do run a 32-bit userspace, perhaps if I had 64-bit userspace, the guest
would be safe. Or maybe not. I have no idea and no time to get a 64-bit
userspace. :-))

-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
