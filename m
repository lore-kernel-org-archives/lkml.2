Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2FZE57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:57:59 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:64868 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab2FZE54 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:57:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120626033158.16434.94698.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe> <20120626033158.16434.94698.stgit@amt.stowe>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Tue, 26 Jun 2012 13:57:25 +0900
X-Google-Sender-Auth: 4X2pGHnN5wIpSMdPzujNaoBgyl8
Message-ID: <CABMQnVJcP+BNMbW+VPNTK7DK=QDse1jwRu43pFV9j81_MueOsg@mail.gmail.com>
Subject: Re: [PATCH 09/16] sh/PCI: Factor 'pcibios_setup()' out of sh
To: Myron Stowe <myron.stowe@redhat.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com, linux@arm.linux.org.uk,
        starvik@axis.com, jesper.nilsson@axis.com, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/26 Myron Stowe <myron.stowe@redhat.com>:
> The PCI core provides a generic (__weak) 'pcibios_setup()' routine that can
> be used by all architectures as a default.  Drop sh's architecture specific
> version in favor of that as it does not need to be over-ridden.
>
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>

Tested-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

-- 
Nobuhiro Iwamatsu
