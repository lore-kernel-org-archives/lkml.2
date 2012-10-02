Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2JBLwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:52:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2JBLwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:52:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 11/12] pinctrl: samsung: use __devinit section for init code
Date: Tue, 2 Oct 2012 11:52:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de> <1348868177-21205-12-git-send-email-arnd@arndb.de> <CACRpkdZv2b8M2Y4BJpqOX72prLHf4aACbmYk=imevX7h-X65QQ@mail.gmail.com>
In-Reply-To: <CACRpkdZv2b8M2Y4BJpqOX72prLHf4aACbmYk=imevX7h-X65QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210021152.30099.arnd@arndb.de>
X-Provags-ID: V02:K0:4AVnlLY8ov+AJmt9F2+tlLJZS83go1cVugK2N8neRVF
 9YB4+RhdpzuQHu+vaLQgtb+RezBVSFkPcLMDs/rhTDqG5ih6Fj
 aj2Ie5HS1Nq2wX/QiEZ2CeozPeo55eU3pPZoorpuJu/Dz10rt0
 RtSxDFBCbEqqKsnfzVm6YEY0L+JLpCCFwlVVIo1loosOyfZehd
 jf2sc8CWwtjev5g7ZpkswAu/16qcsz7qEq3CRib50R82NRyJ9s
 qC1i8YxIc70PI+hfKuTeFw99CDqVc/ivkJpMk2MiB6LOeBCL96
 JPb36EDEzYVqviROEU0zPtz5lWhPQErZKEE0OOYhvSlmeKcz+g
 ugmHfNejWJq9EpWBOYPk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2012, Linus Walleij wrote:
> On Fri, Sep 28, 2012 at 11:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > The samsung pinctrl driver has a probe function that is
> > __devinit and that calls a lot of other functions that are
> > marked __init, which kbuild complains about.
> >
> > Marking everything __devinit means that the code does not
> > discarded when CONFIG_HOTPLUG is set, which is a little
> > more wasteful, but also more consistent
> >
> > Without this patch, building exynos_defconfig results in:
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> I think the Samsing pinctrl driver has landed into next from some
> branch in ARM SoC so you probably know better than me
> where this thing should be merged...
> 

Sorry, I was too late for this one. Can you pick it up now that the
driver is merged?

	Arnd
