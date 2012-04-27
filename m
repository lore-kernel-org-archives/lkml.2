Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab2D0Fef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:34:35 -0400
Received: from mx2.netapp.com ([216.240.18.37]:26028 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2D0Fee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:34:34 -0400
X-IronPort-AV: E=Sophos;i="4.75,489,1330934400"; 
   d="scan'208";a="643781485"
From: "S, Sreeram" <Sreeram.S@netapp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ravishankar <cyberax82@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@mit.edu>
Subject: RE: IP options IP_RECVOPTS on Linux 2.6 - Kindly comment
Thread-Topic: IP options IP_RECVOPTS on Linux 2.6 - Kindly comment
Thread-Index: Ac0jjqxjoILH3aKGQFyeeZZJQ60udQAdoLiAAAwTGrAADw27gAAOlU3g
Date: Fri, 27 Apr 2012 05:34:33 +0000
Message-ID: <402249329CEF3E49AACD14423D8386EE03C6B60D@SACEXCMBX03-PRD.hq.netapp.com>
References: <402249329CEF3E49AACD14423D8386EE03C6B35C@SACEXCMBX03-PRD.hq.netapp.com>
	 <CAO_LctSkkqctOEaC_CPDB7yHCzgAYe+G3rPQBFT3jh1-cCT22A@mail.gmail.com>
	 <402249329CEF3E49AACD14423D8386EE03C6B5E5@SACEXCMBX03-PRD.hq.netapp.com>
 <1335504701.2775.67.camel@edumazet-glaptop>
In-Reply-To: <1335504701.2775.67.camel@edumazet-glaptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.53]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3R5YjCY019215

Thanks Eric.
I shall try that and I will reply. Thanks for the hint.

Regards,
Sreeram

-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Friday, April 27, 2012 11:02 AM
To: S, Sreeram
Cc: Ravishankar; linux-kernel@vger.kernel.org; Andy Lutomirski
Subject: RE: IP options IP_RECVOPTS on Linux 2.6 - Kindly comment

On Fri, 2012-04-27 at 05:25 +0000, S, Sreeram wrote:
> Thanks a lot Ravi for the response.
> 
> But, the IP header is 40 bytes and so I think I should expect all 
> those 40 bytes to be returned to my program when I enable this option.
> Isnt that correct ?
> 
> Here, TTL and TOS are getting returned because I have explicitly 
> enabled the returns of IP_RECVTTL and IP_RECVTOS to my program using 
> setsockopt. Otherwise even they wouldnâ€™t have been returned.
> 
> I still think that the kernel is not returning what it should return 
> when I enable IP_RECVOPTS. Please correct me if you think I am wrong.
> 
>  
> 
> Also, what are the other ways of getting the IP header other than RAW 
> sockets, if the current approach does not work?
> 
>  

IP options are not IP header.

Try to send an IP packets with options, and your program will work.




ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
