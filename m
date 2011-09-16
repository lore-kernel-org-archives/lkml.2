Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1IPBfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 21:35:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55599 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab1IPBfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 21:35:02 -0400
Message-ID: <4E72A785.2050207@cn.fujitsu.com>
Date: Fri, 16 Sep 2011 09:33:57 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Lutomirski <luto@mit.edu>
CC: Linus Torvalds <torvalds@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc6 boot problem reason searching
References: <web-606439650@zbackend1.aha.ru> <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com> <web-606831561@zbackend1.aha.ru> <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com> <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com> <CA+55aFzay+U5JA0Q6vdjmV73yG0OUXnO_zi6Q0c6iTkmozSSiw@mail.gmail.com> <web-607296211@zbackend1.aha.ru> <CAObL_7HAxg0j3ywpTy1-5Y5vBBQLSTiF7AZ0bctRsPOLKA8ZNA@mail.gmail.com> <CA+55aFwEKNEN8QPpBhAkDQ4UGFtSDtpdwFRSkTvnhaYRTmrsOA@mail.gmail.com> <CAObL_7Gjk91MFSwbaMnfdxwrM0mDGxWtDBaKMoimg2FSUqjAUg@mail.gmail.com> <CA+55aFxmW7rFEpanD-ngB-Egx5j1q8b_u31Keo3+s-TJ13UZGA@mail.gmail.com> <CA+55aFxcibMZbEpJzP-LfV1aYFM-n9ctEqNMZ_k4XJxoZPfbrg@mail.gmail.com> <web-607463067@zbackend1.aha.ru> <CA+55aFzEedjD0vqemMhYEEH99ya6tk9X4ViGwm_vuVy-41w3=A@mail.gmail.com> <CAObL_7EuUyeJ2ebhMhYgY_4O+wUE-rHbc4aBvEKaGrimxU_z7A@mail.gmail.com>
In-Reply-To: <CAObL_7EuUyeJ2ebhMhYgY_4O+wUE-rHbc4aBvEKaGrimxU_z7A@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-16 09:33:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-16 09:33:42,
	Serialize complete at 2011-09-16 09:33:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 09:27 AM, Andrew Lutomirski wrote:
> 2011/9/15 Linus Torvalds<torvalds@linux-foundation.org>:
>> On Thu, Sep 15, 2011 at 6:10 PM, werner<w.landgraf@ru.ru>  wrote:
>>> Meanwhile 3.1-rc6 with the patch by L.T. is compiled, and it boots, with the
>>> original allyesconfig with M486 , so that insofar that problem is resolved.
>>> So that 95% of the population of poorer parts of the world (which have 486
>>> computers) continue to be benefited also by version 3.1 .
>>
>> Thanks for testing.. I suspect you're the only one who ever actually
>> builds i486 kernels any more - at least development kernels ;)
>
> Would you prefer for me to test your patch or to submit my one-liner?
>
> --Andy

Andy:
Please see commit a7f934d4f16144cb9521b62e9b8c9ac0118097da
Thanks
-Wanlong

>
>>
>>                   Linus
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

