Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900Ab1HHQH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:07:29 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60258 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1HHQH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACna6ryx4k5fFmqbDPZ3pdDA_SbjZQQVaJNQyALkx0i8+S-7hA@mail.gmail.com>
References: <201107230012.p6N0CZSM002466@hera.kernel.org> <CAMuHMdU0Cba9xFjfD6Fq1MqE5xZeDnsdN8qipmR6jQH9J6X4vQ@mail.gmail.com>
 <CACna6ryx4k5fFmqbDPZ3pdDA_SbjZQQVaJNQyALkx0i8+S-7hA@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 8 Aug 2011 18:07:07 +0200
Message-ID: <CA+XFjioJPCvp+=-3Eg06bzHuXGbFCUoyGguhTL5DqqcpqN0ZXQ@mail.gmail.com>
Subject: Re: b43: LCN-PHY add place for new PHY support
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/8 Rafa³ Mi³ecki <zajec5@gmail.com>:
> W dniu 8 sierpnia 2011 13:57 u¿ytkownik Geert Uytterhoeven
> <geert@linux-m68k.org> napisa³:
>> On Sat, Jul 23, 2011 at 02:12, Linux Kernel Mailing List
>> <linux-kernel@vger.kernel.org> wrote:
>>> Gitweb:     http://git.kernel.org/linus/1d738e64f3d957d56c1b51e64ebdef986a8760e3
>>> Commit:     1d738e64f3d957d56c1b51e64ebdef986a8760e3
>>> Parent:     0cd20a278e1ef9da9f6a987942794c9d65af8c4d
>>> Author:     Rafa³ Mi³ecki <zajec5@gmail.com>
>>> AuthorDate: Thu Jul 7 15:25:27 2011 +0200
>>> Committer:  John W. Linville <linville@tuxdriver.com>
>>> CommitDate: Fri Jul 8 11:11:25 2011 -0400
>>
>>> diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
>>> new file mode 100644
>>> index 0000000..c046c2a
>>> --- /dev/null
>>> +++ b/drivers/net/wireless/b43/phy_lcn.h
>>
>>> \ No newline at end of file
>>
>> Woops...
>>
>> gcc/cpp also complains:
>>
>> drivers/net/wireless/b43/phy_lcn.h:14:28: warning: no newline at end of file
>
> Sorry, I didn't know we want empty lines at the end. I also don't
> think it's mentioned in kernel's CodingStyle.

I'm pretty sure it is basic Unix knowledge that all text files SHOULD
(RFC 2119) end with a newline character, unless otherwise noted
explicitly. In fact, many Unix text editors automatically insert a
newline at the end, and forbid you from deleting it.

>
> I'll fix that when doing LCN stuff, if you agree separated patch is not needed.
>
> My gcc didn't complain :|
>
> --
> Rafa³
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
