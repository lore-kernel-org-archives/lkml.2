Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2E2Xe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 19:34:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2E2Xe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 19:34:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120529.192438.1186076504142998357.davem@davemloft.net>
References: <1338333250-11974-1-git-send-email-devendra.aaru@gmail.com>
	<20120529.191810.2141710455829509698.davem@davemloft.net>
	<CAHdPZaMfSKRzT4MN-5g3c1bOah4CB80aWyVhGKu1Z5AXTj2uTw@mail.gmail.com>
	<20120529.192438.1186076504142998357.davem@davemloft.net>
Date: Wed, 30 May 2012 05:04:57 +0530
Message-ID: <CAHdPZaOsMKHzT_JGnHtJE11ibtzb-hbHVp=tmuv_nL6Dnamwyw@mail.gmail.com>
Subject: Re: [PATCH] r6040: disable pci device if the subsequent calls (after
 pci_enable_device) fails
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: florian@openwrt.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Wed, May 30, 2012 at 4:54 AM, David Miller <davem@davemloft.net> wrote:
> From: "devendra.aaru" <devendra.aaru@gmail.com>
> Date: Wed, 30 May 2012 04:52:08 +0530
>
>> Hello David,
>>
>>
>> OK, so may i put these two changes into one and send it? or you want
>> it to be two patches?
>
> It's up to you.

OK, i will be sending two patches shortly(with sequence numbers (git
format-patch -s -n)).

This time i have done compile testing and got no warnings.

Thanks,
Devendra.
