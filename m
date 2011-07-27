Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1G0PEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:04:31 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35994 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1G0PE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:04:29 -0400
Message-ID: <4E3028EC.1010200@gmail.com>
Date: Wed, 27 Jul 2011 08:04:12 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC V2]remove extra semicolons from various parts of the kernel
References: <1311746789-2870-1-git-send-email-justinmattock@gmail.com> <CAJd=RBB4=VH=2Z2H3BP+2cvf8KmpbnkVuWyFdK24pp94gZwu9Q@mail.gmail.com>
In-Reply-To: <CAJd=RBB4=VH=2Z2H3BP+2cvf8KmpbnkVuWyFdK24pp94gZwu9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 05:01 AM, Hillf Danton wrote:
> On Wed, Jul 27, 2011 at 2:06 PM, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> From: "Justin P. Mattock"<justinmattock@gmail.com>
>>
>> This is a resend from the original, changing the title from PATCH to
>> RFC(since this is a review for commit, and I should have put that the first go around).
>> and also removing some of the commit's with ia64 and bash since it is significant.
>> let me know if I might have missed anything etc..
>>
>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
> Acked-by: Hillf Danton<dhillf@gmail.com>
>
> btw, would you please, Justin, share howto tame gmail not to malform the patch
> produced by git diff, say wrap lines with more than 80-char, or howto
> config git?
>

Cool Thanks!

all I do is use git send email to send out the patches(seems to not 
mangle things). As for tweaking any of the clients to work properly or 
even gmail itself, I would not really know what todo(need to do my 
homework with that). All info is under: Documentation/email-clients.txt

hope it helps.

Justin P. Mattock

