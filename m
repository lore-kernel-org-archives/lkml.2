Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3AGNeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:34:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:63474 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3AGNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:34:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Date: Mon, 7 Jan 2013 13:33:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>, linux-arm-kernel@infradead.org,
        arm@kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <CAOesGMg6afPjBc82FEOwzwn-nBAFPY7K_udJRJO1bBrtCk3Yvg@mail.gmail.com> <20130107015929.GA27346@verge.net.au>
In-Reply-To: <20130107015929.GA27346@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301071333.56733.arnd@arndb.de>
X-Provags-ID: V02:K0:qaYM9Okm4bjhOPozT9Sn7wOzTYc8Uv1rAN7p9y5+UMG
 P++g7M86fORi/tEUFHEQY/2vkcmA1Kl8TCV0hg1If87PPhCokM
 4B7Egyd+uA7onFyjf/uGf3MLzI8JQK9geqzgAnV9TrX478CexC
 VHgU7sKncHTPPW/u9WTgnhWiPd94eylFTw68RFGkgoT7JhuhKV
 QBzNUBcQJM7KV8IpUvtKgTs+VyZyJyXtRPxN19Xv3SXkvtbFMD
 xzOOPBrYfJQn9pJNoj5p2F2q6z5KzTDa39JJHqGh6XiyRS5fOu
 VG1IcNMi87ucd5MYK6CiK1EGWh21mhhXNYIm1tMaLdks8hO94B
 F3PVHl/iqSzPS868myXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 January 2013, Simon Horman wrote:
> I have my kota2 board up and running now and I believe that
> the correct value is 0x1e000000. I will apply a patch to my
> defconfigs branch accordingly.

Ok, thanks!

Should we mark that patch for stable backports?

	Arnd
