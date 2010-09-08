Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0IHPnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:43:21 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:53681 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0IHPnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:43:18 -0400
Message-ID: <4C87AEEC.3000309@seas.upenn.edu>
Date: Wed, 08 Sep 2010 11:42:36 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
References: <4C7EB3A3.7050402@gmail.com> <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu> <20100906194838.GB31384@core.coreip.homeip.net> <4C855BAA.4000900@gmail.com> <20100906233203.GA18048@seas.upenn.edu> <4C85E1A7.2010906@gmail.com> <alpine.LNX.2.00.1009081147070.26813@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1009081147070.26813@pobox.suse.cz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-08_05:2010-09-08,2010-09-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009080100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/10 05:47, Jiri Kosina wrote:
> On Tue, 7 Sep 2010, Jiri Slaby wrote:
> 
>>>>>> +
>>>>>> +		ret = ntrig_version_string(&data[2], buf);
>>>>>> +
>>>>>> +		dev_info(&hdev->dev,
>>>>>> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
>>>>>> +			 buf, data[2], data[3], data[4], data[5]);
>>>>>> +
>>>>>> +		kfree(buff);
>>>>
>>>> In any case, this doesn't compile...
>>>>
>>>>>> +	}
>>>
>>> Jiri, I moved the code to a separate function as Dmitry suggested, and compiled a kernel from a clean tree using 
>>> gcc-3.4 (I think).
>>
>> This version is OK. In the previous one, there was
>> char *buf;
>> ...
>> kfree(buff);
> 
> Dmitry, Jiri, thanks a lot for taking care reviewing the patch while I 
> have been lagging behind.
> 
> Now applied, thanks Rafi.

Thanks Jiri, and thanks for all the feedback.
