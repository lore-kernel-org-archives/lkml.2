Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab2EIXFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 19:05:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15365 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2EIXFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 19:05:04 -0400
X-AuditID: cbfee61a-b7b97ae000004342-a4-4faaf81e10e2
Message-id: <4FAAF81E.5040406@samsung.com>
Date: Thu, 10 May 2012 08:05:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: arnd@arndb.de, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Extcon: Add MAX8997 extcon driver for MUIC feature
References: <1336534304-26273-1-git-send-email-cw00.choi@samsung.com>
 <20120509221810.GA17417@kroah.com>
In-reply-to: <20120509221810.GA17417@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 05/10/2012 07:18 AM, Greg KH wrote:

> On Wed, May 09, 2012 at 12:31:44PM +0900, Chanwoo Choi wrote:
>> This patchset use Extcon framework in extcon-max8997 driver to control
>> external connector instead of max8997-muic driver which is implemented
>> with callback function through platform_data to control external connector.
>>
>> So, first patch add MAX8997 extcon driver (drivers/extcon/extcon-max8997.c),
>> the last patch remove previous MAX8997 MUIC driver(drivers/misc/max8997-muic.c)
>> which support MUIC feature of Maxim MAX8997 with callback function.
> 
> Nice job, all applied now.
> 

Thank you for your reply and applied.

Best Regards,
Chanwoo Choi
