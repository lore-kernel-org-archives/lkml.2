Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2LDKLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 05:11:48 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53173 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098Ab2LDKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 05:11:46 -0500
Message-ID: <50BDCC4F.10505@ilyx.ru>
Date: Tue, 04 Dec 2012 14:11:27 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Xiaobing Tu <xiaobing.tu@intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Alek Du <alek.du@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] tty: Correct tty buffer flushing.
References: <50B55A93.4090900@ilyx.ru> <50B6A652.9000107@ilyx.ru> <20121129135418.4237e7f8@pyramind.ukuu.org.uk> <50B76D96.20809@ilyx.ru> <20121204085359.03894026@bob.linux.org.uk>
In-Reply-To: <20121204085359.03894026@bob.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2012 12:53, Alan Cox wrote:
>> Main idea here -  we never flash last (struct tty_buffer) in the
>> active buffer. Only data for ldisc. (tty->buf.head->read =
>> tty->buf.head->commit). At that moment driver can collect(write) data
>> in buffer without conflict.
> 
> This one I agree with (sorry it took a while to get to, I wanted to sit
> and think carefully about it as it is subtle and clever)
> 
> Can you generate a single patch which reverts the unneeded locks and
> adds this instead. Add a Signed-off-by and send it to Greg to get it
> into 3.8/3.9 somewhere.
> 
> Thanks
> 
> Alan
> 

OK.
Thank you.

