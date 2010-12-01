Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0LAHWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:22:40 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60428 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab0LAHWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:22:38 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6183"; a="64797708"
Message-ID: <4CF5F7BA.7070909@codeaurora.org>
Date: Wed, 01 Dec 2010 12:52:34 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Kevin McNeely <Kevin.McNeely@cypress.com>
CC: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Simtec Linux Team <linux@simtec.co.uk>,
        Luotao Fu <l.fu@pengutronix.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
References: <Kevin McNeely <kev@cypress.com> <1289327120-2612-1-git-send-email-kev@cypress.com> <4CE163CC.1060202@euromail.se> <FB9C2CB29A07AB45B575A4E8D2AABC090119784D@labamba.mis.cypress.com>
In-Reply-To: <FB9C2CB29A07AB45B575A4E8D2AABC090119784D@labamba.mis.cypress.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On 11/19/2010 11:09 PM, Kevin McNeely wrote:
> Hello Henrik,
> 
> Thank you for reviewing this code submission.
> 
> I have replied to each of your comments below.
> 
> I would like to resubmit to include the changes.
> 
> Thanks and best regards,
> Kevin
> 
> 
>> -----Original Message-----
>> From: Henrik Rydberg [mailto:rydberg@euromail.se]
>> Sent: Monday, November 15, 2010 8:46 AM
>> To: Kevin McNeely
>> Cc: Dmitry Torokhov; David Brown; Trilok Soni; Samuel Ortiz; Eric
> Miao;
>> Simtec Linux Team; Luotao Fu; linux-input@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH] touchscreen: Cypress TTSP G3 MTDEV Core Driver
>>
>> On 11/09/2010 07:25 PM, Kevin McNeely wrote:
>>
>>> Initial release of Cypress TTSP Gen3 Core Driver.
>>> Core Driver includes platform data definition file,
>>> core driver definition file, and core touchscreen
>>> touch handling of device data. Generates
>>> multi-touch input events.
>>>
>>> Signed-off-by: Kevin McNeely <kev@cypress.com>
>>
>>> ---
>>
>>
>> Thanks for your submission. Please find comments on MT inline. On a
>> general
>> note, it is strongly recommended that this driver be converted to the
>> MT slots
>> (type B) protocol.
> 
> I will resubmit with Protocol A only at this time.  I will remove the
> Tracking ID's.
> 

Any comments on this? 

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
