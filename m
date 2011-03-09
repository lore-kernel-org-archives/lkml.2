Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1CIVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:34:50 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51184 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1CIVes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:34:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wTTaZKKRo23M2IXUi2SG3o4n33V1L+y6cE9Lvvr7QCwD7I1I1clXdex07s1PP9fUaJ
         p0ym55y6joeHoxyWtM9O5IBXkF+O4cxQI7OlmJRkPtjiKSJV0RTdJFu0PSYmSYKs3sI9
         M1LrQUUJEFeMV1RWUaNk9WmI+94shJqj7nCOg=
MIME-Version: 1.0
In-Reply-To: <20110309212643.GA27747@suse.de>
References: <1299703801-19378-1-git-send-email-vinaysawal@gmail.com>
	<20110309212643.GA27747@suse.de>
Date: Wed, 9 Mar 2011 13:34:47 -0800
Message-ID: <AANLkTik3iPj8qU=ij-RdwTtdtzy7T4LJ_G-AJ0-V96xL@mail.gmail.com>
Subject: Re: [PATCH] Staging: bcm: Bcmnet: fixed checkpatch script issues
From: Vinay Sawal <vinaysawal@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 1:26 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Mar 09, 2011 at 12:50:01PM -0800, Vinay Sawal wrote:
>> Fixed all issues reported by checkpatch script on this file.
>>
>> Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
>> ---
>>  drivers/staging/bcm/Bcmnet.c |   51 +++++++++++++++++++++++++++++------------
>>  1 files changed, 36 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
>> index a6ce239..4e38a76 100644
>> --- a/drivers/staging/bcm/Bcmnet.c
>> +++ b/drivers/staging/bcm/Bcmnet.c
>> @@ -1,3 +1,23 @@
>> +/*
>> +    bcm/Bcmnet.c
>> +    Bcm network driver
>> +
>> +    This program is free software; you can redistribute it and/or modify
>> +    it under the terms of the GNU General Public License as published by
>> +    the Free Software Foundation; either version 2 of the License, or
>> +    (at your option) any later version.
>
> Why "or any later version"?  Are you allowed to relicense the code here?
>
>> +
>> +    This program is distributed in the hope that it will be useful,
>> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +    GNU General Public License for more details.
>> +
>> +    You should have received a copy of the GNU General Public License
>> +    along with this program; if not, write to the Free Software
>> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>
> Are you willing to track the office movements of the FSF for the next 40
> years and send patches updating the address?  If not, NEVER, include
> this paragraph, it's pointless.
>
> Anyway, as others stated, this is not acceptable for a "fix checkpatch
> warnings" type of patch, please redo it.

Fair point. I'll re-generate the patch.

thanks,
vinay

>
> thanks,
>
> greg k-h
>
