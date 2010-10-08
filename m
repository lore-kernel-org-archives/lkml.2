Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab0JHJSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:18:06 -0400
Received: from mail.atheros.com ([12.19.149.2]:48226 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198Ab0JHJSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:18:05 -0400
Message-ID: <4CAEE1DB.1070202@Atheros.com>
Date: Fri, 8 Oct 2010 14:48:19 +0530
From: Suraj Sumangala <suraj@Atheros.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>
Subject: Re: Peculiar stuff in hci_ath3k/badness in hci_uart
References: <20101007214134.6bcd2e8f@lxorguk.ukuu.org.uk>
In-Reply-To: <20101007214134.6bcd2e8f@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On 10/8/2010 2:11 AM, Alan Cox wrote:
> Noticed this while looking at Savoy's stuff
>
>
> ath_wakeup_ar3k:
>
>         int status = tty->driver->ops->tiocmget(tty, NULL);
>
I agree, it will be a problem if the underlying driver try to access the 
"struct file". Is there any other way I can get the MCR status here 
without providing user space pointer?

>
> Fortunately I looked further and the further I looked the more fun it gets
>
> in hci_uart we have
>
>                  len = tty->ops->write(tty, skb->data, skb->len);
>
Regards
Suraj
