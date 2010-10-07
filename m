Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab0JGSUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:20:05 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64420 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab0JGSUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=WUTEVl1pZZ6JSMHD9mRfdFbK37Sd+F028d8arWvosfhqvri4E3cBc25LTrtCgiJaAO
         A78fiKV4ywfFv5j4WPnE9V/xZjZipcrRui7bVqMRaklUKR4qDTI/nZbdTCRElZJclLPt
         7ehPwEwRuQgiw57Ke1eKrI22rMeFWtRScsVgg=
MIME-Version: 1.0
In-Reply-To: <20101007175103.GA31639@kroah.com>
References: <1286423526-2777-1-git-send-email-rahul.ruikar@gmail.com> <20101007175103.GA31639@kroah.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Thu, 7 Oct 2010 23:49:41 +0530
Message-ID: <AANLkTinxOAFuBjUaZVxHAM_n+xcV1qVEgVZ-up9kDRDP@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
To: Greg KH <greg@kroah.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok no problem.
I had sent it because yesterday you asked me to send it again.

- Rahul Ruikar





On 7 October 2010 23:21, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 07, 2010 at 09:22:06AM +0530, Rahul Ruikar wrote:
>> Fix for following cases
>> - Call device_unregister() only when device_register() succeeds.
>> - Call put_device() when device_register() fails.
>> - Call device_remove_file() only when device_create_file() succeeds.
>>
>> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
>> ---
>>  drivers/usb/gadget/langwell_udc.c |   14 +++++++++++---
>>  drivers/usb/gadget/langwell_udc.h |    4 +++-
>>  2 files changed, 14 insertions(+), 4 deletions(-)
>
> This patch doesn't apply at all to my tree.  Can you redo it against the
> latest linux-next release?
>
> thanks,
>
> greg k-h
>
