Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab2EGI51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 04:57:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65452 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2EGI5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 04:57:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Subject: Re: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Date: Mon, 7 May 2012 08:04:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205070804.29154.arnd@arndb.de>
X-Provags-ID: V02:K0:2rQCiU6Qew1iLalOpcYGEEG4JYRcE6KcK0pZz1b+wq6
 4Us/a+Zjb4rElUzmanW6wT4WjnJ6z6J6fb3ZzxT0VcMTb6xhhQ
 aSr0rl/wAzyTr+ImIAXABGMJYjI63BAAZ/eTcCkB9GrPpPaubv
 sRA0rgctJRwVjaWVsMF+RdGmTOhYmxr7apt6rQd17eeC16k3jP
 gPf0kW1kESZhMEa8MPtZo0XzV6KWcFlaf9deGo9D8pcYz5SJ6t
 /RoCnLrg15mFDGtNMXWgdMW6DA4ooLqX5wXlm7mMYI2P09dCkX
 OtQSXmoKNGJv3IaDUsEGcyNdgQDCvzToqTFqwmllJpyzDk/L+Z
 7nsbFIFA3VUAAERrfoH8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 May 2012, Hiroshi DOYU wrote:
> Tegra AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
> High-performance Bus (AHB) architecture.
> 
> The AHB Arbiter controls AHB bus master arbitration. This effectively
> forms a second level of arbitration for access to the memory
> controller through the AHB Slave Memory device. The AHB pre-fetch
> logic can be configured to enhance performance for devices doing
> sequential access. Each AHB master is assigned to either the high or
> low priority bin. Both Tegra20/30 have this AHB bus.
> 
> Some of configuration params could be passed from DT too if needed.
> 
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Arnd Bergmann <arnd@arndb.de>

Acked-by: Arnd Bergmann <arnd@arndb.de>

for the driver, but please fix the issue pointed out by Russell.

	Arnd

