Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab2HGLeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 07:34:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62006 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab2HGLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 07:34:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Date: Tue, 7 Aug 2012 11:34:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org
References: <1344184373-9670-1-git-send-email-haojian.zhuang@gmail.com> <201208071128.27616.arnd@arndb.de> <20120807113230.GE24257@flint.arm.linux.org.uk>
In-Reply-To: <20120807113230.GE24257@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208071134.43640.arnd@arndb.de>
X-Provags-ID: V02:K0:6Id8EZCLveuWx/Q8w7kqMVwwc/ySlTThbOPucVUwAmK
 OfuFTcIzBflmA1iJxJA3PQT+1o5C0moL7QlW48ztvQ4qfJ/4bQ
 L9T3uGpYagDDu1OI8YIZ4iEve5iAPruRpoHwwsA3MtBzO4B/t/
 oiYr4cck8voC6IYu70m344jHlUAnmuMUGtOLBHpJiWdlkgfFac
 8tSnONU/RVsn+bsVGnSsiE4gckwGJWhfS5Ja7Cb/3G3ww/+Qts
 vKcoXmvwZ+OwgRKCzCh4tcOzsQgDa48hb8UNuEJvXPuWNhv3xC
 KuHF/6hZIm/XqFkefVmSR8btpfX33HoDL9z33qgO2EF4fbFoQs
 4kjkTvNFYmFNAPBN/oFU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012, Russell King wrote:
> On Tue, Aug 07, 2012 at 11:28:27AM +0000, Arnd Bergmann wrote:
> > If we introduce a new IORESOURCE_OTHER, I would actually prefer to
> > define it to 0x00000000 for purely aesthetic reasons, the effect
> > should be the same as using 0x00000300.
> 
> I'd suggest not, because we can use that to detect uninitialized
> resources (and we probably do so in some places.)  IOW, I think that's
> asking for problems when this moves outside platform code.

Good point. Let's use 0x00000300 then.

	Arnd
