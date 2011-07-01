Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1GARNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:13:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1GARNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:13:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Tabi Timur-B04825" <B04825@freescale.com>
Subject: Re: [PATCH 7/7] [v6] drivers/virt: introduce Freescale hypervisor management driver
Date: Fri, 1 Jul 2011 19:12:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "Gala Kumar-B11780" <B11780@freescale.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "greg@kroah.com" <greg@kroah.com>, "akpm@kernel.org" <akpm@kernel.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-console@vger.kernel.org" <linux-console@vger.kernel.org>
References: <1307652726-4356-1-git-send-email-timur@freescale.com> <201106092304.55479.arnd@arndb.de> <BANLkTi=3r=UQYJVqRLRe-eu7rdkXQS-ESQ@mail.gmail.com>
In-Reply-To: <BANLkTi=3r=UQYJVqRLRe-eu7rdkXQS-ESQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107011912.50119.arnd@arndb.de>
X-Provags-ID: V02:K0:O9jd4IppgbK8PY1JguYVWCcHdquhDZg6ymykkSlqauV
 i8Rha82J0rUgB7bdC+juRdF2/oZ9bJwWy/HCQu1s32p0q9wnx8
 NA202hqEssZXlsAwCX1SZgYCMPnSzWT9tgBOHnnvUT49IZK3gP
 uXS1QDv8/OqKNa4vzVA9pagzvBO9I+NnIP1sMcatfcpC/rmkXS
 GGAUerG+GQVxRbrl0vP5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 July 2011, Tabi Timur-B04825 wrote:
> On Thu, Jun 9, 2011 at 4:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Thursday 09 June 2011 22:52:06 Timur Tabi wrote:
> >> Add the drivers/virt directory, which houses drivers that support
> >> virtualization environments, and add the Freescale hypervisor management
> >> driver.
> ....
> >>
> >> Signed-off-by: Timur Tabi <timur@freescale.com>
> >
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> So I've made the changes that people have asked for, and Arnd has
> acked this driver.  Who's going to pick it up?  Who will be the
> maintainer for drivers/virt?  I'd really like to see this driver in
> 3.1, and there's not much time left.
> 
I'd say merge it  through the powerpc tree, and list yourself for
the driver, but not the entire directory.

	Arnd
