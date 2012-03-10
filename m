Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2CJQVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 11:21:43 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51145 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2CJQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 11:21:42 -0500
Message-ID: <4F5B7F8A.1040000@gmail.com>
Date: Sat, 10 Mar 2012 21:51:30 +0530
From: Prasanna Kumar T S M <prasannatsmkumar@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Rares Aioanei <krnl.list@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Git pull on linux-next tree shows "Performing inexact rename
 detection"
References: <4F5A4BE7.60308@gmail.com> <4F5B364A.5000209@gmail.com>
In-Reply-To: <4F5B364A.5000209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2012 04:38 PM, Rares Aioanei wrote:

> On 03/09/2012 08:28 PM, Prasanna Kumar T S M wrote:
>> Doing "git pull" on linux-next tree always shows "Performing inexact
>> rename detection" for a very long time (more than a hour and going). It
>> also uses more than 1.5GB of RAM (out of 2GB RAM) in my system. Not able
>> to do any thing when this is happening - even maximising a window takes
>> 2 minutes once such a situation is reached. I am killing the command
>> with a Ctrl + C as I am not able to do any work.
>>
>> What is the reason for this? What it does internally? Is there any way
>> to circumvent this? I don't want to clone linux-next again (that seems
>> to be the worst case solution).
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> The first Google search result gave me this:
> http://git.661346.n2.nabble.com/Merging-limitations-after-directory-renames-interesting-test-repo-td6041103.html
> 
> 
> While long and pretty technical, it will shed some light, I believe.
> Good luck.
> 


As mentioned in the thread it uses up all my RAM and also does a lot of
paging. In such situations I am not able to use the system. The big
issue is that it takes a very long time (I have waited for 1 hour and
more yet it did not stop). Is there any short cut route to pull the code?

Thanks,
PrasannaKumar
