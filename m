Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab1LLFZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 00:25:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1LLFUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 00:20:31 -0500
MIME-Version: 1.0
In-Reply-To: <20111209111205.04780196@pyramind.ukuu.org.uk>
References: <1323410421-10465-1-git-send-email-sonic.adi@gmail.com>
	<1323410421-10465-2-git-send-email-sonic.adi@gmail.com>
	<20111209111205.04780196@pyramind.ukuu.org.uk>
Date: Mon, 12 Dec 2011 13:20:29 +0800
Message-ID: <CAJxxZ0OPPHeusg-u89i5SOsSeVTH44jP3_x5BbJ8w=nB-Qh5Pw@mail.gmail.com>
Subject: Re: [PATCH 2/2] serial: bfin-uart: Remove ASYNC_CTS_FLOW flag for
 hardware automatic CTS.
From: Sonic Zhang <sonic.adi@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,


On Fri, Dec 9, 2011 at 7:12 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> +#ifdef CONFIG_SERIAL_BFIN_CTSRTS
>>                       uart->port.flags |= ASYNC_CTS_FLOW;
>> +#endif
>
> As an aside could the cts/hard cts etc be passed as properties to the
> platform device rather than ifdeffed ?
>
> Alan

As Mike mentioned, these Macros are used to keep the code smaller when
user doesn't want to enable UART flow control feature.

I will sent out V2 against the latest kernel next tree.


Sonic
