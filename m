Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab2FZHkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 03:40:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55880 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2FZHkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 03:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120615212918.GB23338@kroah.com>
References: <1339601248-3251-1-git-send-email-linkinjeon@gmail.com>
	<CAKYAXd9sbVL9Ut4nZOg5Mt3ZuCOouUq64d-ifjtbO0TnaU1XvA@mail.gmail.com>
	<20120615212918.GB23338@kroah.com>
Date: Tue, 26 Jun 2012 16:40:46 +0900
Message-ID: <CAKYAXd-njKyZozDsUJjJDVEF+6rJRnXpzxm5da1tEy_SPqq0rA@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] scsi: fix internal write cache issue on usb hdd.
From: Namjae Jeon <linkinjeon@gmail.com>
To: James.Bottomley@hansenpartnership.com
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>, mdharm-usb@one-eyed-alien.net,
        stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James.

Would you please check these patches ?
I am waiting for your response.

Thanks.

2012/6/16, Greg KH <gregkh@linuxfoundation.org>:
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> On Fri, Jun 15, 2012 at 12:51:58PM +0900, Namjae Jeon wrote:
>> Hi Greg.
>>
>> Would you check this patch-set ?
>
>
> I can't do much about scsi core patches, sorry.  If James acks them, I
> can take them through my tree.
>
> thanks,
>
> greg k-h
>
