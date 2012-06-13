Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2FMB16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:27:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62295 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab2FMB15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:27:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120613011114.GF6765@kroah.com>
References: <1339511190-2440-1-git-send-email-linkinjeon@gmail.com>
	<20120613011114.GF6765@kroah.com>
Date: Wed, 13 Jun 2012 10:27:55 +0900
Message-ID: <CAKYAXd-9VXpNwUSnsgrDbXAwzSPnBnep6kWGZhbzB623LF0grw@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] usb: storage: update usb devices for write cache
 quirk in quirk list.
From: Namjae Jeon <linkinjeon@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: James.Bottomley@hansenpartnership.com, mdharm-usb@one-eyed-alien.net,
        stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/13, Greg KH <gregkh@linuxfoundation.org>:
> On Tue, Jun 12, 2012 at 10:26:30AM -0400, Namjae Jeon wrote:
>> Update information of Seagate Portable HDD and WD My Passport HDD in
>> quirk list.
>>
>> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
>> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
>> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
>> ---
>>  drivers/usb/storage/unusual_devs.h |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>
Dear Greg.
> What happened to the 2 other patches in this series?
The reason is that I tried to send patch again after making the
mistake(Patch number).
I will resend the patches after arranging.
>
> And why is your From: email address different from your Signed-off-by:
> address?  If you are emailing from a different email account than your
> "real" one, please put a "From: My name <email_address>" as the first
> line in the body of the text for the patch, so git will get things
> correct (see the file, Documentation/SubmittingPatches for details about
> this.)
>
> So, care to resend these so I can apply them?
Yes, sure, I will resend the patches after changing.
Thanks.
>
> thanks,
>
> greg k-h
>
