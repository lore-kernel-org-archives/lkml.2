Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab0EFLQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 07:16:50 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:41762 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab0EFLQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 07:16:48 -0400
Message-ID: <4BE2A51B.2030608@mev.co.uk>
Date: Thu, 6 May 2010 12:16:43 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100422 Thunderbird/3.0.4
MIME-Version: 1.0
To: "nios2-dev@sopc.et.ntust.edu.tw" <nios2-dev@sopc.et.ntust.edu.tw>
CC: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Nios2-dev] [PATCH 2/2] serial: Add driver for the Altera UART
References: <cover.1273048151.git.tklauser@distanz.ch>	<095aab012b2a6b3bbf4c7bc04294bb9c19316318.1273048151.git.tklauser@distanz.ch>	<1273142684.3477.22.camel@gentoo-ija64.mev.local> <4BE2A34C.1040301@mev.co.uk>
In-Reply-To: <4BE2A34C.1040301@mev.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/10 12:09, Ian Abbott wrote:
> On 06/05/10 11:44, Ian Abbott wrote:
>> Those four functions shouldn't grab port->lock because the caller in
>> serial_core.c grabs it before calling them.
> 
> Oh, and that also applies to altera_uart_set_mctrl() - the caller grabs
> port->lock before calling it.

And altera_uart_get_mctrl().

(And for completeness, altera_uart_enable_ms() but the current
implementation doesn't grab it anyway as it's just an empty function.)

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
