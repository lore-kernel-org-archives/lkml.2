Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0KEHV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:21:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56646 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab0KEHVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:21:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Ef1VvwFXlT8e7uVxXGPipA+ZpdwjRWd6MUAE3vAAeXZXSF/7eltYfLabYZK20vEOJp
         FePNOvQekyYLYmKngzNfUuBYSYfN7BaisDftjnqiPAiiiOfI5Eb3MU0ThwYpTWtcgC3w
         R3gCrCFvpQVrzY6wu2BFkVwe2Gtf1k2TwVVOI=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=KmwWzSLqVVc9krrGxJX+L=diPDSr7Wkof-=Wd@mail.gmail.com>
References: <AANLkTikL4Ng0mJmeO0p_gtZWticd6NO3b9daHcRX4q1Q@mail.gmail.com>
	<AANLkTiknaHiWUzOH+MjAujk_+0JfX2x2auRCgFjUqhU-@mail.gmail.com>
	<AANLkTimtyAwuiG-yeKUVrviVB513vX9_q-2yjuo1mjTu@mail.gmail.com>
	<AANLkTi=KmwWzSLqVVc9krrGxJX+L=diPDSr7Wkof-=Wd@mail.gmail.com>
Date: Fri, 5 Nov 2010 16:21:23 +0900
Message-ID: <AANLkTimJb1+vGn-7NEcXwQ-f6-msH4bJ=ttsY91a--sX@mail.gmail.com>
Subject: Re: mmotm 2010-11-03-12-17: memcg build fail
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg Thelen <gthelen@google.com>, Andrea Righi <arighi@develer.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 4:07 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Fri, Nov 5, 2010 at 2:39 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
>> On Fri, Nov 5, 2010 at 2:55 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>>> Forgot cc lkml
>>>
>>> On Fri, Nov 5, 2010 at 1:54 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> Build failed without __divdi3 on i386, known issue?
>>>>
>>>> mm/built-in.o: In function `mem_cgroup_dirty_info':
>>>> /home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1251: undefined
>>>> reference to `__divdi3'
>>>> /home/dave/vdb/build/mm/linux-2.6.36/mm/memcontrol.c:1259: undefined
>>>> reference to `__divdi3'
>>>> make: *** [.tmp_vmlinux1] Error 1
>>>>
>>
>> We should have used do_div.
>> Below patch solve the problem?
>
> Hi,
>
> quilt report it as malformed, I create a patch mannualy, and It works.
> Feel free to add my tested-by line


In my office, I couldn't use any port except 80.
Gmail's web interface always mangles the content. (I hope gmail
supports plain mode)
I will send the formal patch after out of office.

Thanks for the testing.


> --
> Regards
> dave
>



-- 
Kind regards,
Minchan Kim
