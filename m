Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2EZHkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 03:40:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55541 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab2EZHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 03:40:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessandro Rubini <rubini@gnudd.com>
Subject: Re: [PATCH 6/6] serial: add amba-pl011-pci
Date: Sat, 26 May 2012 07:39:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Russell King <linux@arm.linux.org.uk>,
        x86@kernel.org, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <cover.1337959750.git.rubini@gnudd.com> <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
In-Reply-To: <b166cb0fce2a67b24da5808604553b4196258f45.1337959750.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205260739.31653.arnd@arndb.de>
X-Provags-ID: V02:K0:Xw1JEx72DRyXjGaen7FWNepH1LAZpKct+Fnx8dzcu7M
 yX2Io4YQs1BwWTELbmL1a9rEwjMnIw5D5FHWrLHnYYhqkEy9qs
 /Ggb3op8eXaVBwUc9jRzQZYH94Oj2yzszfTNKukUmS+LNDEbWR
 zJorWaqzf/HzhJ5/Xhiq0m04FKtiW/SIvJ3gHEz8tNbxCDyF0Q
 8GfHWCr5HdNiXql1oF3ECRbDrJJjWaMUnLIlYpnbnE6ODp/ZH5
 eAR5yRvk3h4auzZhdL297OETc7GNSyij0rTCeyQVNZWRSFGfAX
 7dLXgNx9e8ceYg7bFyDFgaizqb4c2K8Ng3bKmIHEH4JROECRsX
 sX9WZAWG6rUXXBU4GXNQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 May 2012, Alessandro Rubini wrote:
> 
> This is a simple PCI driver that registers an amba device
> in its probe function. It successfully drives the 4 serial
> ports of the sta2x11 I/O Hub.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>

Aside from the dma mask, this looks almost entirely generic. Would it
be possible to make this a generic pci-amba driver that lives under
drivers/amba/ and does not care about the type of device behind it?

	Arnd
