Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab3AHFmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:42:32 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:38521 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab3AHFmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:42:31 -0500
Message-ID: <50EBB1BE.3070501@gmail.com>
Date: Tue, 08 Jan 2013 09:42:22 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Staging: comedi: addi_common.h: checkpatch.pl fixes
References: <1357395175-6077-1-git-send-email-lijo.kernel@gmail.com> <1357395175-6077-2-git-send-email-lijo.kernel@gmail.com> <20130107223941.GA3913@kroah.com> <ADE657CA350FB648AAC2C43247A983F00206D6C98F77@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206D6C98F77@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 02:50 AM, H Hartley Sweeten wrote:
> On Monday, January 07, 2013 3:40 PM, Greg KH wrote:
>> On Sat, Jan 05, 2013 at 06:12:55PM +0400, Lijo Antony wrote:
>>> Reduced line lengths to 80 chars by removing extra spaces.
>>>
>>> Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
>>> ---
>>>   .../staging/comedi/drivers/addi-data/addi_common.h |   20 ++++++++++----------
>>>   1 file changed, 10 insertions(+), 10 deletions(-)
>
> <snip>
>
>> As you didn't do this for all fields in the structure, it's not really
>> worth doing it for just these, right?
>>
>> The proper thing to do is use kerneldoc format and document it all at
>> the top of the structure, care to do that instead?
>
> Hopefully I will soon get the rest of the addi-data drivers split off of the
> addi_common stuff. This will effectively remove this header file so I'm
> not sure it's worth making patches against it.

Ok, I will wait!
If the file is still around after your cleanup, I will make changes as 
per Greg's suggestion.

Thanks,
-lijo


