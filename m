Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2E2KN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 06:13:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2E2KN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 06:13:27 -0400
MIME-Version: 1.0
In-Reply-To: <3646407.261CWqact8@flexo>
References: <1338206223-26781-1-git-send-email-devendra.aaru@gmail.com>
	<1659482.3g1Zl6FDuM@flexo>
	<CAHdPZaPWM3MfyARfwOm2KkKPPvm4dEfncF47N2xASyp27HdzsA@mail.gmail.com>
	<3646407.261CWqact8@flexo>
Date: Tue, 29 May 2012 15:43:26 +0530
Message-ID: <CAHdPZaM+UyaHv=HF0q1=qp7wTk_LXaF_+W8q5K-x+So5Bd0FSw@mail.gmail.com>
Subject: Re: [PATCH] r6040: disable pci device if the subsequent calls (after
 pci_enable_device) fails
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

>> On Tue, May 29, 2012 at 2:50 PM, Florian Fainelli <florian@openwrt.org>
> wrote:
>
>>
>> Thanks for the Ack.
>> I found one more problem. Its when mdiobus_alloc fails in
>> r6040_init_one, we need to do call to the netif_napi_del and set the
>> NULL to pci_set_drvdata, at  err_out_unmap.
>
> Ok, can you please submit a patch to fix this issue as well? Thanks!
> --
Ok sure. will be doing it shortly.
> Florian

Thanks,
Devendra.
