Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab2EHCZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:25:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45932 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757974Ab2EHCZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:25:32 -0400
X-AuditID: cbfee61b-b7c60ae000000c58-6f-4fa8841a7edc
Message-id: <4FA8842E.8070801@samsung.com>
Date: Tue, 08 May 2012 11:25:50 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Extcon: add MAX8997 extcon driver
References: <4FA87BBF.1040107@samsung.com> <20120508021214.GA3001@kroah.com>
In-reply-to: <20120508021214.GA3001@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2012 11:12 AM, Greg KH wrote:
> On Tue, May 08, 2012 at 10:49:51AM +0900, Chanwoo Choi wrote:
>> This patch add extcon-max8997 driver to support the muic feature
>> of Maxim max8997 by using Extcon framework.
>>
>> The extcon-max8997 driver is implemented based on 'drivers/misc/
>> max8997-muic.c' and then use Extcon interface instead of callback
>> function in struct max8997_muic_platform_data to notify cable state
>> of notifee which want to know always newly cable state when external
>> connector(e.g., USB, TA, JIG) is attached or detached.
> 
> Does that mean we can delete the max8997-muic.c driver if this is
> accepted?

Yes, I have plan to delete max8997-muic.c driver for using
extcon-max8997 driver.
I will resend new patchset including following patch at once:

[PATCH 1/2] Extcon: add MAX8997 extcon driver
[PATCH 2/2] misc: MAX8997: Remove max8997-muic driver

Best regards,
Chanwoo Choi




