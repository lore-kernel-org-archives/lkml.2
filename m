Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2EETVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:21:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2EETVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:21:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Sat, 5 May 2012 19:21:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <201205050722.45500.arnd@arndb.de> <201205052108.03001.rjw@sisk.pl>
In-Reply-To: <201205052108.03001.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051921.13209.arnd@arndb.de>
X-Provags-ID: V02:K0:+3+tKZtCYKJHJZoE9mBUL2CSInM9erhRO8WdMwajfwR
 MaUFuN3p10MzQp8YG093rD9g7NthrCNY5X0FBmBKT4eKcmoHwF
 oaWzwFXCdQOUij9d+FDob5WE5sgsOV891yqPhjyEe4lCdnwXjC
 oHU+n0W4DblP9qrF1M1NaU9oOvbqRjdGwZVhSK70LWxUwjG+9c
 mDtjQG6flDSn03eJRf+b6zMpTatBfrJl1gYv7lbcv4m4gIJOCa
 P4lZ2pjCzjTInvAiJ8APv0sHKprl8VRLYqidJGDyBOcq/1Ngnf
 qlMtbqEA6zfGGqDNF14Q6FhuFa+5hzH8fP5GPfIRS/lDwN33AZ
 mseGx4N0BYVQ6Bn62G28=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2012, Rafael J. Wysocki wrote:
> Now, if you insist on us having a separate mach- directory for every platform
> (SoC), we can do that I think, but then we should start with splitting up the
> existing mach-shmobile into a number of SoC-specific directories rather than
> adding new mach- directories for random new parts, because that goes against
> our development history to date, which is important too IMHO.

All the chips in there so far share a common ancestry and they all use a
significant subset of the same drivers shared with arch/sh: i2c-sh_mobile,
sh-dma-engine, sh_cmt, sh-sci, sh_tmu, intc, pfc and sh_clk. AFAICT, this one
uses none of those and apparently was developed by NEC before the merger with
Renesas.

	Arnd
