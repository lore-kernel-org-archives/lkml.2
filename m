Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab2EUPaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:30:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54873 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2EUPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:30:15 -0400
Message-ID: <4FBA5F82.7080003@gmail.com>
Date: Mon, 21 May 2012 08:30:10 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NEXT]staging: "rts_pstor" Fix typos.
References: <1337609955-15544-1-git-send-email-justinmattock@gmail.com> <20120521143530.GC4637@mwanda> <4FBA5737.3010209@gmail.com> <20120521152626.GE4629@mwanda>
In-Reply-To: <20120521152626.GE4629@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 08:26 AM, Dan Carpenter wrote:
> On Mon, May 21, 2012 at 07:54:47AM -0700, Justin P. Mattock wrote:
>> On 05/21/2012 07:35 AM, Dan Carpenter wrote:
>>> On Mon, May 21, 2012 at 07:19:15AM -0700, Justin P. Mattock wrote:
>>>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>>>
>>>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>    ^
>>> Your scripts are adding an extra space here.i
>>
>> after git format-patch my signature is in the subject line. pressing
>> enter a few times moves it down. is there a git command for properly
>> aligning this?
>
> The first line is the subject and then you need to leave the next
> line of the commit blank.
>
> regards,
> dan carpenter
>
>

ahh.. I know what im doing wrong, im not doing all of this while doing 
git commit -s -a.  I add the subject etc.. after committing and 
formatting the patch.

Justin P. Mattock
