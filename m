Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1CARDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 12:03:19 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33026 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab1CARDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 12:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ohUdlx04eCiqowCUrwL/QYeypUPYJClpWv4GQ7nN5PdFo4Eo2BsfLSh2fHXSP85lYe
         sklI4FcoOYotHyq2hppWuj6wbuTB2WHvkpASYnSQnM/EX9j54F7q4oTTvSI5kEVESqtf
         l0Lnx82mNM/7S8wyrYxkzjN4l+A0fhhRAmLpY=
Message-ID: <4D6D26CE.6020303@gmail.com>
Date: Tue, 01 Mar 2011 20:03:10 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: denys@visp.net.lb
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NMI received for unknown reason, 2.6.38-rc6 regression?
References: <950d04b27ce43565cdef24e4072d7e71@visp.net.lb> <4D6D1A0B.3050903@gmail.com> <9f4d7fae5845b91debc86a65d51bf96a@visp.net.lb>
In-Reply-To: <9f4d7fae5845b91debc86a65d51bf96a@visp.net.lb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 07:42 PM, denys@visp.net.lb wrote:
...
>>
>> nmi_watchdog=0 should help here, actually a nit was fixed by
>> https://patchwork.kernel.org/patch/566611/
>> which is not in 2.6.38-rc6 but I rather suspect it'll be in -rc7 or
>> final .38. If you have an ability
>> to pickup it and test -- this would be great!
 >
> I test it, and it seems helps. At least on one host, and yes, seems all of them P4.
>

ok, thanks! ping me if any :)

-- 
     Cyrill
