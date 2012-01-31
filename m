Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2AaKlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:41:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63638 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2AaKlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:41:10 -0500
MIME-Version: 1.0
In-Reply-To: <20120130.201929.1758603770664566022.davem@davemloft.net>
References: <1327643159-1302-1-git-send-email-tomoya.rohm@gmail.com>
	<20120130.125219.2077768183344205118.davem@davemloft.net>
	<CANKRQniQs95kUhyDeP2V7cyOFE1gyi-ihZufmNoi_SGSXm3MGQ@mail.gmail.com>
	<20120130.201929.1758603770664566022.davem@davemloft.net>
Date: Tue, 31 Jan 2012 19:41:09 +0900
Message-ID: <CANKRQnhtBrjN4BYoLLmc42sffOzc9WfAhLkZMWCuFxTFw2GdUA@mail.gmail.com>
Subject: Re: [PATCH 1/3] ethernet/pch_gbe: Change company name OKI
 SEMICONDUCTOR to LAPIS Semiconductor
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: jeffrey.t.kirsher@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David

I have two questions.

Q1. How should I handle "Copyright" ?

Q2. As I said before, "Intel EG20T PCH" was deleted by someone.
So, I want to retrieve the description. Can I do ?

Thanks.
tomoya

2012/1/31 David Miller <davem@davemloft.net>:
> From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
> Date: Tue, 31 Jan 2012 09:35:26 +0900
>
>> I can understand your saying.
>>
>> If I post like below, is this patch acceptable for you ?
>> +       tristate "OKI/LAPIS SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
>>
>> BTW, I think need consistency for "Change company/product name" as a
>> whole of linux.
>> Because other patches for the same series "change company name" I
>> posted have already accepted.
>> e.g.(GPIO, USB device, DMA, UART, I2C)
>
> I mainly object to moving the driver around, and failing to retain
> the old name especially in user visible contexts such as Kconfig
> variables, help text, and module parameters.
