Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2DSJtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:49:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38855 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2DSJtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:49:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAEH94LhinOW-NPJqqaCAhULqXqvFdShnThiKhemc5VzXCp-7BQ@mail.gmail.com>
References: <CA+dmLLeNG6Sb_k9sdE9QTMjbBJxd_r7ay5uNxLVV_E5u-=abrw@mail.gmail.com>
	<1334827666.24764.245.camel@marge.simpson.net>
	<CAEH94LhinOW-NPJqqaCAhULqXqvFdShnThiKhemc5VzXCp-7BQ@mail.gmail.com>
Date: Thu, 19 Apr 2012 17:49:48 +0800
Message-ID: <CADxeRwmb0TnAD6tH5Zw5kEreXS=Nqn365XMod8-wMRwT2DY+sw@mail.gmail.com>
Subject: Re: 20120419 disk scheduler
From: Steven Liu <lingjiujianke@gmail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, sunzixun <faye.zixun@gmail.com>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3J9oOvU025635

Hi Zhi Yong Wu

          What's you said?


ÔÚ 2012Äê4ÔÂ19ÈÕ ÏÂÎç5:31£¬Zhi Yong Wu <zwu.kernel@gmail.com> Ğ´µÀ£º
> 2012/4/19 Mike Galbraith <efault@gmx.de>:
>> ÎÒ²»ÖªµÀ¶àÉÙ LKML ¶ÁÕß¿ÉÒÔÔÄ¶ÁÕâÆªÎÄÕÂ¡£
> very good, hehe. +1
>>
>> On Thu, 2012-04-19 at 17:15 +0800, sunzixun wrote:
>>> -Ğí¼ÓÇ¿(110781198) 3:33:12 PM
>>> ÎÊÒ»¸öÎÊÌâ£º ¶ÔÓÚÒ»¸öblock ÎÒÃÇ×öIO£¬ËäÈ»»á¾­¹ıdisk schedulerÄÇÒ»²ã£¬ÎÒÏëÎÊµÄ¾ÍÊÇ ÊÇ²»ÊÇ ËùÓĞÇé¿öÏÂIO
>>> scheduler¶¼¿ÉÒÔ±£Ö¤Õâ¸öblockÀïÃæ sectorµØÖ·ÔÚÇ°ÃæµÄ sectors Ò»¶¨±ÈÔÚºóÃæµÄÏÈ±»flushµ½´ÅÅÌÉÏ¡£
>>> eric(3251550) 3:33:31 PM
>>> ²»ÄÜ°¡¡£
>>> Ëï×ÓÜ÷ (448981776) 3:36:36 PM
>>> ÎÒ¾õµÃÄÜµÄ°É£¿
>>> -eric(3251550) 3:38:35 PM
>>> ²»ÄÜ£¬ºÜ¸´ÔÓ¡£
>>> eric(3251550) 3:38:52 PM
>>> ioÊÜ¶àÖØ¿ØÖÆ¡£
>>> -eric(3251550) 3:39:11 PM
>>> ÒªÏë±£Ğò¡£ÒªÓÃbarrier ioÕâÖÖ·½Ê½¡£
>>> Ëï×ÓÜ÷ (448981776) 3:39:13 PM
>>> ¾Í¿´ block size Èç¹ûºÍsectorÒ»Ñù´ó
>>> Ëï×ÓÜ÷ (448981776) 3:40:04 PM
>>> ÎÒ¸Ğ¾õ»¹ÊÇÓ¦¸Ã¿ÉÒÔ°¡
>>> -eric(3251550) 3:40:13 PM
>>> ³ı·ÇÕâ¸öÒ»¸öio£¬¶øÇÒ²»ÄÜ±»²ğ·Ö¡£
>>> eric(3251550) 3:40:36 PM
>>> blockºÍsectorÒ»Ñù´ó¡£»¹Ì¸ºÎÇ°ÃæµÄsectorºÍºóÃæµÄsector
>>> Ëï×ÓÜ÷ (448981776) 3:41:22 PM
>>> ¶Ô ÄãÈ»ºó·´¹ıÀ´Ïë
>>> Ëï×ÓÜ÷ (448981776) 3:41:39 PM
>>> Ò»Ñù´ó ÊÇ¿ÉÒÔ±£Ö¤µÄ ¡£¡£ÄÇ²»Ò»Ñù´ó ÔõÃ´²»±£Ö¤ÄØ
>>> eric(3251550) 3:43:09 PM
>>> ²»Ò»Ñù´ó¡£¡£¾ÍÂé·³ÁË¡£¡£
>>>   -eric(3251550) 3:43:17 PM
>>> Òª±»²ğ·Ö¡£
>>>   -eric(3251550) 3:43:43 PM
>>> Ğ´io¶¼Òª±»²ğ³É4k£¬4k´¦Àí¡£
>>>   -eric(3251550) 3:44:02 PM
>>> ±£Ö¤Ë³Ğò£¬ÄÚºË×¨ÃÅÓÃÁËÒ»ÖÖ½á¹¹À´´¦Àí¡£
>>>   -eric(3251550) 3:44:06 PM
>>> barrier io.
>>>   -Ëï×ÓÜ÷ (448981776) 3:44:20 PM
>>> ¿´À´ÎÒ»¹ÒªÏëÏë
>>>   -eric(3251550) 3:44:55 PM
>>> ¿´ÎÄµµ¡£
>>>   -Ëï×ÓÜ÷ (448981776) 3:49:05 PM
>>> ¼ÓÇ¿ÊÇÎÊ ÄÚºË±£Ö¤°´sector £¬»¹ÊÇ°üÀ¨×îÖÕµÄÓ²ÅÌÂäµØ£¿
>>>   -Ëï×ÓÜ÷ (448981776) 3:49:29 PM
>>> Èç¹û¾­¹ıraid cache £¬´ÅÅÌ½»²æÒò×Ó  ÄÇÈ·Êµ¸´ÔÓÒ»Ğ©
>>>   -Ëï×ÓÜ÷ (448981776) 3:50:18 PM
>>>
>>>   -BJ-Ğí¼ÓÇ¿(110781198) 3:52:12 PM
>>> ¶÷  Ó¦¸ÃÊÇ²»ÄÜ±£Ö¤µÄ£¬µÃ¿´´ÅÍ·µÄµ±Ç°Î»ÖÃ¾ö¶¨
>>>   -BJ-Ğí¼ÓÇ¿(110781198) 3:53:08 PM
>>> µ«Èç¹û²»ÊÇ¼òµ¥µÄ´ÅÅÌ£¬¶øÊÇSANµÄÄÇÖÖ£¬ IOÒª×ßfiber channel»òÕßinfinibandµ½Ô¶´¦µÄ´ÅÅÌ£¬ÊÇ²»ÊÇÒ²²»ÄÜ±£Ö¤
>>>   -eric(3251550) 3:53:20 PM
>>> ¶¼²»ÄÜ¡£
>>>   -Ëï×ÓÜ÷ (448981776) 3:55:22 PM
>>> ÄãÎÊ io sched ÎÒ¾õµÃÕâ²ãÊÇ¿ÉÒÔµÄ
>>>   -Ëï×ÓÜ÷ (448981776) 3:55:30 PM
>>> µ«ÊÇÓ²¼ş ÄÇ¿Ï¶¨²»ÄÜ
>>>   -eric(3251550) 3:56:05 PM
>>> io schedÒ²²»ÄÜ¡£¡£
>>>   -BJ-Ğí¼ÓÇ¿(110781198) 3:56:06 PM
>>> ÎÒ¾õµÃÕâ²ã ÔÚÅÅ¶ÓµÄÊ±ºò  Ó¦¸ÃÒ²ÓĞ¿ÉÄÜÈÃºóÃæsectorµÄ²å¶Óµ½Ç°ÃæÀ´°É£¿
>>>   -eric(3251550) 3:56:38 PM
>>> ÅÅ¶ÓÊÇ°´ĞòµÄ¡£µ«ÊÇËæÊ±¿ÉÄÜ±»ÖØĞÂ¶¨Î»¡£
>>>   -eric(3251550) 3:56:58 PM
>>> µ÷¶ÈÒª¿¼ÂÇ¶öËÀµÄÇé¿ö¡£
>>>   -BJ-Ğí¼ÓÇ¿(110781198) 3:57:06 PM
>>> ±»ÖØĞÂ¶¨Î»µÄÊ±ºò  ÊÇ¿¼ÂÇÄÄĞ©ÒòËØ£¿
>>>   -Ëï×ÓÜ÷ (448981776) 3:57:11 PM
>>> io sched ÎªÊ²Ã´²»ÄÜ£¿
>>>   -Ëï×ÓÜ÷ (448981776) 3:57:39 PM
>>> ÖØĞÂ¶¨Î» io sched ÊÇ²»ÖªµÀ´ÅÍ·ĞÅÏ¢µÄ
>>>   -eric(3251550) 3:57:39 PM
>>> ¶öËÀ¡£¡£³¤Ê±µÈ´ı¡£¡£ÇëÇóºÏ²¢¡£µÈµÈ¡£
>>>   -Ëï×ÓÜ÷ (448981776) 3:57:49 PM
>>> ¶Ô°¡ £¬µÈ´ı ºÍºÏ²¢ Ò²ÊÇË³ĞòµÄ
>>>   -eric(3251550) 3:57:51 PM
>>> Èí¼ş²»¹Ü ´ÅÍ·ĞÅÏ¢¡£
>>>   -eric(3251550) 3:57:56 PM
>>> ÄÇÊÇncqµÄÊµÏÖ¡£
>>>   -Ëï×ÓÜ÷ (448981776) 3:57:58 PM
>>> ²»»áÌø»Ø
>>>   -Ëï×ÓÜ÷ (448981776) 3:58:27 PM
>>> ±ÈÈç Ò»¸öblock ·Ö³Éscetor 1 2 3 4
>>> ÇëÎÊÊ²Ã´µ÷¶È»á ×ß³É 4 2 1 3
>>>   -eric(3251550) 3:59:04 PM
>>> Ö»ÊÇµ÷¶ÈÕâÒ»²ãÂğ£¿
>>>   -Ëï×ÓÜ÷ (448981776) 3:59:12 PM
>>> ÊÇ°¡
>>>   -eric(3251550) 3:59:58 PM
>>> µ÷¶ÈÕâ²ã²»»á¡£
>>>   -BJ-Ğí¼ÓÇ¿(110781198) 4:01:08 PM
>>> ¼ÙÉèµ÷¶È²ã²»»á£¬ÄÇÃ´µ÷¶È²ãÏÂÃæ   ÄÄĞ©Çé¿ö»áµ¼ÖÂÂÒĞò£¿
>>>   -eric(3251550) 4:03:28 PM
>>> ºÜ¶àÇé¿ö¡£
>>>   -Ëï×ÓÜ÷ (448981776) 4:03:45 PM
>>> µ÷¶È¿ÉÒÔ¿´Ô´Âë ¡£ÎÒÍíÉÏ×ĞÏ¸¿´¿´¡£¡£
>>>
>>> Ó²¼ş¾ÍÌ«¶àÁË£¬Ïñ¸Õ²ÅEMC¸çÃÇ¸æËßÎÒµÄ½»²æÒò×Ó
>>>   -eric(3251550) 4:03:48 PM
>>> ÉÏ²ãÓ¦ÓÃ»¹¿ÉÄÜ²¢·¢¡£
>>>   -eric(3251550) 4:04:17 PM
>>> I/O barrier requests are used to guarantee ordering around the barrier requests.
>>>   -eric(3251550) 4:04:39 PM
>>> All requests queued before a barrier request must be finished (made it
>>> to the physical medium) before the barrier request is started, and all
>>> requests queued after the barrier request must be started only after
>>> the barrier request is finished (again, made it to the physical
>>> medium).
>>>   -eric(3251550) 4:05:04 PM
>>> ±£Ğò¡£¡£¡£Ç°ÃæµÄ±ØĞëÍê³É¡£ºóÃæµÄ±ØĞëµÈ±£ĞòioÍê³ÉÖ®ºóÔÙÍê³É¡£
>>>   -eric(3251550) 4:05:13 PM
>>> ±»²åÈë ´ò¶ÏÒ²²»ĞĞ¡£
>>>   -eric(3251550) 4:05:51 PM
>>> Ö»±£Ö¤ 1£¬2£¬3£¬4£¬5Ò²²»ĞĞ¡£»¹±ØĞë²»ÄÜÖĞ¼ä±»²åÈëĞÂµÄio
>>> N§²æìrybX¶Çv^)Şº{.n+·¥{êçzX§¶¡Ü}²Æz&j:+vêçzZ++zf£¢h~izw¥¢?¨è&)ß¢f^jÇ«ym@Aa¶Ú 0¶ìhi
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Regards,
>
> Zhi Yong Wu
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
