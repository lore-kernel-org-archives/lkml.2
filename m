Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1IVOk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 10:40:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64021 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1IVOkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 10:40:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH REPOST 1/2] arm/dt: Tegra: Update SDHCI nodes to match bindings
Date: Thu, 22 Sep 2011 16:40:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, nicolas.pitre@linaro.org,
        Shawn Guo <shawn.guo@linaro.org>, devicetree-discuss@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org
References: <1316537186-26753-1-git-send-email-swarren@nvidia.com> <201109202301.56983.arnd@arndb.de> <CAOesGMg4kBH77Ou1xyyVT-Ojxg=9uyxmfsmhbbKquru=j+z6Gg@mail.gmail.com>
In-Reply-To: <CAOesGMg4kBH77Ou1xyyVT-Ojxg=9uyxmfsmhbbKquru=j+z6Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109221640.16985.arnd@arndb.de>
X-Provags-ID: V02:K0:jmdPwO76xQZVPlxFBwjaZH2knFAAbCiB3/1btKsjAsj
 PiMzSA6dQ+CTbMS2w3PvLGqtEiF2hvNTUGwG7q+CfoTrB+T6VB
 EgU+HHuE2gbD/LZr+uxRhcmQ4nOIkCcbDPlsRNAywR8cyBI+yA
 GK9NLpsX/lsToJt6futW3b3cyeRZaGDVlkN10MX7iSYMxwlnNY
 kYIQXlp6Z524NGXqZUJ/k+vr/kL0aIieiL1miKiO+t3l4QD7p6
 YnH7NxiXgSYgIcjgqV52xB9d24aQ8/h04f5mpfjSVxpUdbFRWy
 yn2SKWLH5E4i6OpaoIjP3Hpt2zemQZQoqOqpBsHqnU+rdjaUL1
 btr9tlu/XmiKk0jn1CiY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 September 2011, Olof Johansson wrote:
> On Tue, Sep 20, 2011 at 2:01 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> > Should I take the other one as well? It's probably better to let that
> > go the proper way through the tegra tree for 3.2, right?
> 
> Given that you have a public tree right now, and I don't (since
> kernel.org is down), please feel free to start a tegra/for-3.2 branch
> for me and apply it there. I'll base further work on top of that if
> needed.
> 
> (There also aren't a whole lot of other patches queued for 3.2 right now).

Ok, I've put it into the next/fixes branch now, so it will be in 3.2.

Thanks,

	Arnd
