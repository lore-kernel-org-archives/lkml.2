Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab0LOQkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:40:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56412 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0LOQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:40:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Date: Wed, 15 Dec 2010 17:40:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <201012151631.11574.arnd@arndb.de> <20101215153540.GA15817@huya.qualcomm.com>
In-Reply-To: <20101215153540.GA15817@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151740.24933.arnd@arndb.de>
X-Provags-ID: V02:K0:JlYSl5DYS9MYVobwv3FaUsU4FG5hdNcuzUjCA4FMKJ1
 0xdxbq9ehOPLR5bFJX2j7LqF0PYIhjWhNgLcjqztUzU8XhsCRO
 l+8ni40vyOKgJewDPLXKt+NIjFVKHh/ct9plv0WD1zI8c5Dekg
 sUXs4Jdg1zDsVtmFKc73DuzKLN4HECVnqel8OTkrTjyHMhuwk4
 ABQtIlrHnal20650ParjA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, David Brown wrote:
> 
> On Wed, Dec 15, 2010 at 04:31:11PM +0100, Arnd Bergmann wrote:
> > On Wednesday 15 December 2010, Stepan Moskovchenko wrote:
> 
> > In this particular case, it's rather confusing, because one would assume
> > that MSM8960 is a subset of MSM8X60!
> 
> Unfortunately, this is not the case, and I'm not sure what better name
> to use for MSM8X60.  The MSM8X60 name covers MSM8260 and MSM8660, but
> MSM8960 is quite a bit different.  Any ideas for better names?

No, you probably lose there, unless you can fall back to code names
instead of product numbers.

My point was really that they should not be exclusive, even if they
are rather different. If the code is structured in a more modular
way, you can turn all MSM/QSD options from the "Qualcomm MSM SoC Type"
choice into separate "bool" config options. You probably don't want
to do that now for all the existing ones, but I would suggest you
try not add more to the pile ;-).

	Arnd
