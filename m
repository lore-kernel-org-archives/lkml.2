Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab2E2KIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:08:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34767 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2E2KIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:08:40 -0400
From: Florian Fainelli <florian@openwrt.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r6040: disable pci device if the subsequent calls (after pci_enable_device) fails
Date: Tue, 29 May 2012 12:06:29 +0200
Message-ID: <3646407.261CWqact8@flexo>
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; x86_64; ; )
In-Reply-To: <CAHdPZaPWM3MfyARfwOm2KkKPPvm4dEfncF47N2xASyp27HdzsA@mail.gmail.com>
References: <1338206223-26781-1-git-send-email-devendra.aaru@gmail.com> <1659482.3g1Zl6FDuM@flexo> <CAHdPZaPWM3MfyARfwOm2KkKPPvm4dEfncF47N2xASyp27HdzsA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 May 2012 15:28:51 devendra.aaru wrote:
> Hello Florian,
> 
> On Tue, May 29, 2012 at 2:50 PM, Florian Fainelli <florian@openwrt.org> 
wrote:

> 
> Thanks for the Ack.
> I found one more problem. Its when mdiobus_alloc fails in
> r6040_init_one, we need to do call to the netif_napi_del and set the
> NULL to pci_set_drvdata, at  err_out_unmap.

Ok, can you please submit a patch to fix this issue as well? Thanks!
--
Florian
