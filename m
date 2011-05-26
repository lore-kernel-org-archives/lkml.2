Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1EZKAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 06:00:49 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37062 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab1EZKAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 06:00:47 -0400
Message-ID: <4DDE249D.9000000@ru.mvista.com>
Date: Thu, 26 May 2011 13:59:57 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Greg KH <greg@kroah.com>, David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-gadget: unlock data->lock mutex on error path in
 ep_write()
References: <4DDDF3EA.6050501@ispras.ru>
In-Reply-To: <4DDDF3EA.6050501@ispras.ru>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-05-2011 10:32, Alexey Khoroshilov wrote:

> ep_write() acquires data->lock mutex in get_ready_ep() and releases it on
> all paths except for one: when usb_endpoint_xfer_isoc() failed. The
> patch adds mutex_unlock(&data->lock) at that path.

> It is similar to commit 00cc7a5faf25b3ba5cf30fcffc62249bdd152006 for ep_read(),

    Please specify that commit's summary in parens.

> it was not fixed at that time by accident.

> Found by Linux Driver Verification project (linuxtesting.org).

> Signed-off-by: Alexey Khoroshilov<khoroshilov@ispras.ru>

WBR, Sergei
