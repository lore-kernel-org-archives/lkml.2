Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2EIAuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 20:50:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9279 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab2EIAt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 20:49:59 -0400
X-AuditID: cbfee61a-b7b97ae000004342-d6-4fa9bf36b561
Message-id: <4FA9BF37.7060302@samsung.com>
Date: Wed, 09 May 2012 09:49:59 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
References: <4FA8EF06.6020108@samsung.com> <20120508160640.GA11368@kroah.com>
In-reply-to: <20120508160640.GA11368@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 01:06 AM, Greg KH wrote:

> On Tue, May 08, 2012 at 07:01:42PM +0900, Chanwoo Choi wrote:
>> This patchset use Extcon framework in extcon-max8997 driver to control
>> external connector instead of max8997-muic driver which is implemented
>> with callback function through platform_data to control external connector.
>>
>> So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
>> the last patch remove previous MAX8997 MUIC
>> driver(drivers/misc/max8997-muic.c)
>> which support MUIC feature of Maxim MAX8997 with callback function.
>>
>> Chanwoo Choi (2):
>>   Extcon: add MAX8997 extcon driver
>>   misc: MAX8997: Remove max8997-muic driver
>>
>>  drivers/extcon/Kconfig          |    8 +
>>  drivers/extcon/Makefile         |    1 +
>>  drivers/extcon/extcon-max8997.c |  542
>> +++++++++++++++++++++++++++++++++++++++
> 
> Your patches are line-wrapped and can not be applied.
> 
> Please fix your email client (read Documentation/email_clients.txt for
> hints) and resend this series.
> 
I'm so sorry. I will repost patchset after fixing line-wrapped issue at once.


Best Regards,
Chanwoo Choi

