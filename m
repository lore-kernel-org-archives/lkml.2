Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab1DALj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:39:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32873 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab1DALj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ub4KDg37oYcFJT2YYbQYkk4uWWsYupBge4qVxhd4ESM08JDX2JigF/Mvo7hOvzPw7/
         zO/WRGlSCcc8YlOcD1eb9EP2v1eE9Sv+iCPLgPTXlRDNSX0t1ZrvQk0JwZPIZ2KDeWAC
         1xuFwLdIheu+odmFl3IozwMP4jRPFYNaGyjF8=
Message-ID: <4D95B96A.3090600@openvz.org>
Date: Fri, 01 Apr 2011 15:39:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dongdong Deng <libfetion@gmail.com>
CC: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        KGDB Mailing List <Kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
References: <4D8A58E1.5090509@openvz.org>	<AANLkTimU3Hw5ZSo86Fv4RUtNPtS3kZBoWm4kh4MQaymu@mail.gmail.com>	<AANLkTim_EDeYGu6_rsSh_3zDTW7mN5+Gwsb0t4HjKx6o@mail.gmail.com>	<4D94BC9D.3040009@windriver.com> <AANLkTikhbKnMuOuVxHSWk2stNGgvEBO1XvGAQ1tVMc8s@mail.gmail.com>
In-Reply-To: <AANLkTikhbKnMuOuVxHSWk2stNGgvEBO1XvGAQ1tVMc8s@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 01:26 PM, Dongdong Deng wrote:
...
>>
>> The net result.   I'll sign-off on the kgdb change and add a TODO item to wait for the jump patching to enter the kernel.
>>
>> Cyrill, I am assuming this is something we want to aim to merge into the 2.6.39 as a regression fix?  I'll try to get a
>> version of Deng Dongdong's patch into linux-next as soon as possible in the mean time.
> 
> Hi Jason,
> 
> Do I need to send a patch to you?  :-)
> 
> BR,
> Dongdong

I've started latest -tip on some ancient p4 machine today and got unknown nmi issue even without kgdb compiled :(
Didn't reveal all the details yet (seems I'll be able to continue investigation at monday only in best case).
But still your patch looks correct to me.

-- 
    Cyrill
