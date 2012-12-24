Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2LXQk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:40:58 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50618 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2LXQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:40:55 -0500
Message-ID: <50D88594.6060601@nvidia.com>
Date: Mon, 24 Dec 2012 09:40:52 -0700
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel@axis.com, Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Joshua Thompson <funaho@jurai.org>, Sam Creasey <sammy@sammy.net>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Ryan Mallon <rmallon@gmail.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH V3 00/11] ARM: delete struct sys_timer
References: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1353349867-28494-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2012 11:30 AM, Stephen Warren wrote:
> Russell, I'm mainly reposting this to see if you have any comments or
> opinion, in particular on the core ARM changes.
> 
> The aim of this series is to remove ARM's struct sys_timer. As a pre-
> cursor, this requires a little re-arrangement of arch_gettimeoffset and
> associated changes to other architectures.
> 
> The full series can be found in git at:

(now at):
git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
arm-timer-rework

I have put this branch into the Tegra tree's for-next branch. Once the
holidays are over, I'll send a pull request to get this into arm-soc as
a baseline branch for others to build on.
