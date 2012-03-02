Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2CBN2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:28:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2CBN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:28:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL v2] at91: irqdomain and device tree for 3.4
Date: Fri, 2 Mar 2012 13:27:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss" <devicetree-discuss@lists.ozlabs.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <4F4F8D66.7040205@atmel.com>
In-Reply-To: <4F4F8D66.7040205@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021327.24417.arnd@arndb.de>
X-Provags-ID: V02:K0:8CA5NnCNmVDmngVpKaVLNL2eOOHqgL/h+VXIoft/vYe
 cF44S/5x2YY+Zl0fHksPHcE5Jv3VKe758tUVMRoyHE9EKSigah
 JT/2N5W1U3IQjy+aBoQn8SwhdvcY2qkXElRxr4MFT6ADPj9H2Z
 9xwZ7gNFC8DX+Mq7iWCx+mzb7FzLAt5RZps64kdYZj9TPNlPT9
 BelqUpRsWR3KIz2/r4EfGs0QGlBWR+tzNzR0JIfQeEcdZWOdcQ
 bEPqxTYq9QJE3DXMtRs8Qh1v7irioeQ5ghr8m7OXoIVzmipbAb
 G1UWOxhDWu5aRudHYVJ8vurbSaF8zlMXdT6UnwwwHE3Y/to9rN
 IzcFnczUEaWmrABXKp6I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2012, Nicolas Ferre wrote:
> This pull request supersedes the previous:
> "[GIT PULL] at91: irqdomain and device tree for AIC and GPIO"
> 
> This series adds irqdomain and device tree support for both the
> interrupt and GPIO controllers of AT91 SoC. It has been discussed a lot
> and I think that I have addressed all comments and advices.
> 
> To the AIC, GPIO device tree work, it also adds the the conversion of the 
> PIT and TC timers, the PIO3 support and some basic LED and gpio-keys entries.
> 
> The irqdomain work takes advantage of Grant's patch series that is present
> in:
> git://git.secretlab.ca/git/linux-2.6 irqdomain/next
> This branch is merged into this tree, on top of at91/base2+cleanup (aka cleanup2)
> and before the application of new AT91 material.
> 
> 
> The following changes since commit 89d4a1753b6632327f18d6c8e0842b366b736621:
> 
>   Merge branch 'irqdomain/next' of git://git.secretlab.ca/git/linux-2.6 (2012-03-01 13:26:51 +0100)
 
Pulled into next/dt, looks good!

Thanks,

	Arnd
