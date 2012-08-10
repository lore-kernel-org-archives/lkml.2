Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2HJT3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 15:29:54 -0400
Received: from fallback6.mail.ru ([94.100.176.134]:51969 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab2HJT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 15:29:52 -0400
Message-ID: <50255E31.8060904@list.ru>
Date: Fri, 10 Aug 2012 23:17:05 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org
Subject: Q: how to control the TTY output queue in real time?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I am writing an app that needs to control the
serial xmit in real-time. What I need is a notification
that the TTY output queue fillup (returned by TIOCOUTQ
ioctl) have dropped below the specified value.
I haven't found anything that can help implementing
this. If I can't get an async notification, the sync
notification will do too, like, for instance, the tcdrain()
call, but with the argument to specify the needed fillup,
below which the function will return.
If there is nothing like this, then even the notification
on every transmitted char will do.
But I've found nothing of the above. :(

Any suggestions how the real-time control can be
implemented?

(please CC me the replies)
