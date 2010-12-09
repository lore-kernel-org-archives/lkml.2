Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab0LIUKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:10:43 -0500
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:39940 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845Ab0LIUKl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:10:41 -0500
X-Greylist: delayed 2027 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Dec 2010 15:10:40 EST
From: Jing Huang <huangj@Brocade.COM>
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>, Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Adapter Linux Open SRC Team" 
	<adapter_linux_open_src_team@Brocade.COM>
Date: Thu, 9 Dec 2010 11:35:42 -0800
Subject: RE: linux-next: Tree for December 9
Thread-Topic: linux-next: Tree for December 9
Thread-Index: AcuXwBPOF4yjnXegSjqBvxriCA0qYQAF7dJw
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CFCB9049@HQ1-EXCH01.corp.brocade.com>
References: <20101209154148.ca4ba4e0.sfr@canb.auug.org.au>
	<AANLkTikjGhkYoR_o3uq-sUEY1daXSRWQgRmMBoVJ-n1=@mail.gmail.com>
	<20101209154900.GA20190@suse.de>
 <AANLkTimh-E2By3YdeapZ-HP-H8+Y+PWkt762zjH0sOEG@mail.gmail.com>
In-Reply-To: <AANLkTimh-E2By3YdeapZ-HP-H8+Y+PWkt762zjH0sOEG@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-09_08:2010-12-09,2010-12-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=1
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1010190000 definitions=main-1012090114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>2010/12/9 Greg KH <gregkh@suse.de>:
>> On Thu, Dec 09, 2010 at 12:46:19PM +0100, Zimny Lech wrote:
>>> Ave
>>>
>>> 2010/12/9 Stephen Rothwell <sfr@canb.auug.org.au>:
>>> > Hi all,
>>> >
>>> > Changes since 20101208:
>>> >
>>>
>>>   LD      drivers/built-in.o
>>> drivers/staging/built-in.o:(.data+0xec80): multiple definition of `log_level'
>>
>> That's coming from the cxt1e1 driver, I'll fix that up to be a "sane"
>> global name.
>>
>>> drivers/scsi/built-in.o:(.data+0xa71c): first defined here
>>
>> That's coming from the drivers/scsi/bfa/ driver, and it too should be
>> fixed as it shouldn't have a global variable with this name in it.
>> Care to let the maintainer of that driver know about this as well?
>

Hi Zimny, 

I will provide a fix for linux-next soon.
Thanks
Jing
