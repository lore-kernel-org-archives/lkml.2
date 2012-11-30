Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2K3Mx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:53:59 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65145 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2K3Mx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:53:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121130082527.GU11248@mwanda>
References: <1354165076-30273-1-git-send-email-yamanetoshi@gmail.com>
	<20121130021026.GB2056@kroah.com>
	<20121130082527.GU11248@mwanda>
Date: Fri, 30 Nov 2012 21:53:57 +0900
Message-ID: <CAOTypNQ7nKK_MtgG5yLgj6aHLntdOrWmYKpeCGJgkZDxH9xJXQ@mail.gmail.com>
Subject: Re: [PATCH] staging/serqt_usb2: Refactor qt_status_change_check() in serqt_usb2.c
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 5:25 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Nov 29, 2012 at 06:10:26PM -0800, Greg Kroah-Hartman wrote:
>> On Thu, Nov 29, 2012 at 01:57:56PM +0900, YAMANE Toshiaki wrote:
>> >
>> > -                           ProcessLineStatus(qt_port, data[i + 3]);
>> > -
>> >                             i += 3;
>> > +                           ProcessLineStatus(qt_port, data[i]);
>>
>> I think you just changed the logic in this function, didn't you?
>
> This should be ok.  The i += 3 was there in the original, it's just
> moved up a line.

Thanks for your kindness reply.

But please discard this patch.
Let me consider this patch again.


Regards,

YAMANE Toshiaki
