Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab1BYG5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:57:21 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1BYG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:57:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mhKkb2WCAFsTjteyYWiRq9AK5t/MByasBJHdNz7qnf2tfdOwjxjbRTruFb1Sf721E0
         +0Khy02Za/2dc5Rmh0Bqb32AY2707x/+ZBKZpTefScRu48p9UV2gQhG0OCJvlDN31q3O
         vD7VqFwlSgFANrvqmZMvCslsxdf/tJbmlPhuM=
Message-ID: <4D6752C9.1090805@suse.cz>
Date: Fri, 25 Feb 2011 07:57:13 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [PATCH 1/1] DVB-USB: dib0700, fix oops with non-dib7000pc devices
References: <1296930047-22689-1-git-send-email-jslaby@suse.cz> <4D664DE5.7020002@gmail.com> <4D6654B2.1080707@infradead.org> <4D665FFF.7050501@suse.cz> <4D6661E4.6040505@infradead.org>
In-Reply-To: <4D6661E4.6040505@infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 02:49 PM, Mauro Carvalho Chehab wrote:
> Em 24-02-2011 10:41, Jiri Slaby escreveu:
>> On 02/24/2011 01:53 PM, Mauro Carvalho Chehab wrote:
>>> Em 24-02-2011 09:24, Jiri Slaby escreveu:
>>>> Hmm, could anybody pick it up?
>>>>
>>>> On 02/05/2011 07:20 PM, Jiri Slaby wrote:
>>>>> These devices use different internal structures (dib7000m) and
>>>>> dib7000p pid ctrl accesses invalid members causing kernel to die.
>>>>>
>>>>> Introduce pid control functions for dib7000m which operate on the
>>>>> correct structure.
>>>
>>> Patrick (DibCom drivers maintainer) has proposed an alternate patch for it [1]
>>> that properly address the issues:
>>>
>>> http://git.linuxtv.org/pb/media_tree.git?a=commitdiff;h=80a5f1fdc6beb496347cbb297f9c1458c8cb9f50
>>>
>>> [1] http://www.spinics.net/lists/linux-media/msg27890.html
>>>
>>> Could you please test it?
>>
>> Yes, I will later.
>>
>> Is there any reason why this is not in Linus' and stable trees and
>> mainly in linux/next already?
> 
> Yes. I'm waiting for confirmation that this patch fixes the reported issue.

Ok, it works as expected.

Tested-by: Pavel SKARKA <paul.sp@seznam.cz>
References: https://bugzilla.novell.com/show_bug.cgi?id=644807

thanks,
-- 
js
suse labs
