Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1DWLOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 07:14:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51952 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1DWLOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 07:14:44 -0400
MIME-Version: 1.0
X-Originating-IP: [14.96.208.152]
In-Reply-To: <20110423054115.GA26504@kroah.com>
References: <1303535297-2586-1-git-send-email-pavan_savoy@ti.com>
	<20110423054115.GA26504@kroah.com>
Date: Sat, 23 Apr 2011 16:44:38 +0530
X-Google-Sender-Auth: BAimgw9L1wrVoaYaK6MPUgqwzNw
Message-ID: <BANLkTi=ewZpPKU7x8PsiDWNN3cGRHxtVzw@mail.gmail.com>
Subject: Re: [PATCH] drivers:misc:ti-st: fix skip remote baud logic
From: Pavan Savoy <pavan_savoy@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Pavan Savoy <pavan.savoy@gmail.com>, linux-kernel@vger.kernel.org,
        Victor Goldenshtein <victorg@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 11:11 AM, Greg KH <greg@kroah.com> wrote:
> On Sat, Apr 23, 2011 at 10:38:17AM +0530, Pavan Savoy wrote:
>> From: Victor Goldenshtein <victorg@ti.com>
>>
>> Texas Instruments WiLink connectivity combo chipsets support custom baud
>> rates over its UART interface.
>> This can be achieved by sending the change remote baud rate command.
>> Since the baud rate can be properly set by the user-space on shared
>> transport the remote chip-side and local host-side baud rate is change
>> by the User Space Init Manager.
>>
>> This patch when encounters the same command inside the firmware,
>> attempts to skip such command since it is handled by the user-space.
>> The logic to skip the command when it is un-commented is fixed by this
>> patch.
>>
>> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
>> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
>> Author:    Victor Goldenshtein <victorg@ti.com>
>
> There is no such thing as an "Author:" tag.
>
> And I know that Victor didn't sign off on this, you can not just add his
> name to this like that, it is not allowed.

Oopsy, Sorry about this one.
I think I saw an out-of-office from victor, I will ask him to mail this one.

Thanks,
Pavan.

> So I now need to get this patch from Victor, with him confirming that he
> has signed off on it, sorry.
>
> greg k-h
>
