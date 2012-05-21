Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103Ab2EUOyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:54:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44440 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab2EUOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:54:52 -0400
Message-ID: <4FBA5737.3010209@gmail.com>
Date: Mon, 21 May 2012 07:54:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NEXT]staging: "rts_pstor" Fix typos.
References: <1337609955-15544-1-git-send-email-justinmattock@gmail.com> <20120521143530.GC4637@mwanda>
In-Reply-To: <20120521143530.GC4637@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 07:35 AM, Dan Carpenter wrote:
> On Mon, May 21, 2012 at 07:19:15AM -0700, Justin P. Mattock wrote:
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>    ^
> Your scripts are adding an extra space here.i

after git format-patch my signature is in the subject line. pressing 
enter a few times moves it down. is there a git command for properly 
aligning this?
>
>>
>> ---
>>
>> The below patch fixes some typos found while reading through rts_pstor.
>
> This could go in the patch description if you wanted.
>
>>
>>   drivers/staging/rts_pstor/ms.c |    2 +-
>>   drivers/staging/rts_pstor/sd.c |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
>> index 0bf6d95..3b75739 100644
>> --- a/drivers/staging/rts_pstor/ms.c
>> +++ b/drivers/staging/rts_pstor/ms.c
>> @@ -2488,7 +2488,7 @@ int reset_ms_card(struct rtsx_chip *chip)
>>
>>   	if (!CHK_MSPRO(ms_card)) {
>>   		/* Build table for the last segment,
>> -		 * to check if L2P talbe block exist,erasing it
>> +		 * to check if L2P table block exist,erasing it
>
> I still have no idea what this comment means but "exist" =>  "exists"
> and it needs a space after the comma.

most of them I have no idea as well.. anyway resending with the fixes..
>
>>   		*/
>>   		retval = ms_build_l2p_tbl(chip, ms_card->total_block / 512 - 1);
>>   		if (retval != STATUS_SUCCESS) {
>
> regards,
> dan carpenter
>

Justin P. Mattock
