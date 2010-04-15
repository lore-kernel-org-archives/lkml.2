Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0DOIid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 04:38:33 -0400
Received: from mail.mellanox.co.il ([194.90.237.43]:57882 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756053Ab0DOIia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 04:38:30 -0400
Message-ID: <4BC6D075.1070405@mellanox.co.il>
Date: Thu, 15 Apr 2010 11:38:13 +0300
From: Amir Vadai <amirv@mellanox.co.il>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9pre)
	Gecko/20100217 Lightning/1.0b1 Shredder/3.0.3pre
MIME-Version: 1.0
To: Andrea Gozzelino <Andrea.Gozzelino@lnl.infn.it>
CC: "Tung, Chien Tin" <chien.tin.tung@intel.com>,
       Steve Wise <swise@opengridcomputing.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
       "rolandd@cisco.com" <rolandd@cisco.com>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>, "mingo@elte.hu" <mingo@elte.hu>,
       Eric B Munson <ebmunson@us.ibm.com>
Subject: Re: Socket Direct Protocol: help (2)
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<2EFBCAEF10980645BBCFB605689E08E9047C7402DA@azsmsx506.amr.corp.intel.com>
	<4BC49E2B.3000804@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405A0@azsmsx506.amr.corp.intel.com>
	<4BC4D22A.6020700@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C7405E9@azsmsx506.amr.corp.intel.com>
	<7037536.1271235105513.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<4BC5D1D3.3020004@mellanox.co.il> <4BC5D529.1060701@mellanox.co.il>
	<2EFBCAEF10980645BBCFB605689E08E9047C79B918@azsmsx506.amr.corp.intel.com>
	<4BC5D9D4.7020702@opengridcomputing.com>
	<2EFBCAEF10980645BBCFB605689E08E9047C79BD12@azsmsx506.amr.corp.intel.com>
	<4BC6B135.2060004@mellanox.co.il>
	<1205877.1271315264088.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
In-Reply-To: <1205877.1271315264088.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2010 08:38:27.0076 (UTC)
	FILETIME=[04A71C40:01CADC77]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17320.004
X-TM-AS-Result: No--17.594200-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be a simple fix and I plan to do soon - just add yourself as
CC in bugzilla  - that way I won't forget to notify you.

- amir

On 04/15/2010 10:07 AM, Andrea Gozzelino wrote:
> On Apr 15, 2010 08:24 AM, Amir Vadai <amirv@mellanox.co.il> wrote:
>
>   
>> I hope to have a fix next week for the first one.
>>
>> Thanks,
>> Amir
>>
>> On 04/14/2010 09:48 PM, Tung, Chien Tin wrote:
>>     
>>>> Tung, Chien Tin wrote:
>>>>     
>>>>         
>>>>>> One more thing - Please open a bug regarding the num_sge
>>>>>> limitation at:
>>>>>> https://bugs.openfabrics.org/
>>>>>>
>>>>>>         
>>>>>>             
>>>>> Done, Bug 2027.
>>>>>
>>>>> Chien
>>>>>
>>>>>       
>>>>>           
>>>> And 2028 opened to request fastreg support.
>>>>
>>>>     
>>>>         
>>> I am open to test fixes for these two bugs.
>>>
>>> Chien
>>>
>>>   
>>>       
>>     
> Hi Amir, 
> Hi Chien,
>
> I understand that the bug 2027 could be solved next week, so I will test
> SDP protocol performance on NE020 cards.
> Is it correct? 
> If yes, could you point out the code modifies?
>
> Keep in touch and take care.
> Regards,
> Andrea
>
>
> Andrea Gozzelino
>
> INFN - Laboratori Nazionali di Legnaro	(LNL)
> Viale dell'Universita' 2
> I-35020 - Legnaro (PD)- ITALIA
> Tel: +39 049 8068346
> Fax: +39 049 641925
> Mail: andrea.gozzelino@lnl.infn.it			
>
>
>   
