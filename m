Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab2EVWEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab2EVWEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:04:50 -0400
Message-ID: <4FBC0E66.809@redhat.com>
Date: Wed, 23 May 2012 00:08:38 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-hid-core: Set intfdata to NULL if probe fails
References: <1337629176-1624-1-git-send-email-hdegoede@redhat.com> <4FBB469B.50801@suse.cz> <4FBB49CE.9020408@redhat.com> <4FBB4E51.6020607@suse.cz> <4FBB5D4C.9090804@redhat.com> <alpine.LNX.2.00.1205230000070.30445@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1205230000070.30445@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/23/2012 12:00 AM, Jiri Kosina wrote:
> On Tue, 22 May 2012, Hans de Goede wrote:
>
>> Well then lets work towards making it guaranteed, since I still believe
>> the following holds true:
>> 1) drvdata is for a driver to store a pointer to driver specific data
>> 2) If no driver is bound, there is no driver specific data associated with
>>     the device
>> 3) Thus logically drvdata should be NULL if no driver is bound.
>>
>> I'll do a patch for the USB-core to ensure that intfdata gets set to NULL
>> on probe failure.
>
> Hans,
>
> I believe this is a good thing per se, but shouldn't this rather be done
> in driver core, to guarantee that this hold across all buses?

Alan Stern said exactly the same thing :)

And I've just finished a patch doing exactly that. I'll send it to the
list right after this email.

Regards,

Hans
