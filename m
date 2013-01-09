Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248Ab3AIVXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:23:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535Ab3AIVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:23:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 11/14] ARM: tegra: tamonten: Add PCIe support
Date: Wed, 9 Jan 2013 21:23:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de> <1357764194-12677-12-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1357764194-12677-12-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301092123.37491.arnd@arndb.de>
X-Provags-ID: V02:K0:gNLshlMKvAcqwvMqVxpiBCahzDNPG1rHf4WfdjWzLVh
 jRm4lvl0gxY9R22S7MxlgREu1V5HtdRMFyYu30lI25ULWEoTE6
 vMP1N5RX61fv5xLtUHPAiWjqme7yvxAtrB87OOFVM2kfTr7Jhe
 VTnxGdraqNiIfBaky0Spb6D4T+7VXYi+HogpiAcbF2wMdk5sCF
 A+YkLWWmW5FbYQzdz3ToZVZibCUZuf1NnSA5U6TgEDlWSRyYZp
 NnnkcpY2x7v+25GmZaeB3VWzAqdbA27h76McGlJdSF1A5UQkDA
 PJRbi4hYhH0RSrITYGGK+Qae2H7oQyD6WesucpGQ5CmGg560Pb
 BYbgWQWw7qd485gADGv4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Thierry Reding wrote:
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/boot/dts/tegra20-tamonten.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It's not clear how this one-line patch adds PCIe support to the
platform. Are you missing the actual change here?

	Arnd
