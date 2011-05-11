Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1EKDDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 23:03:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47548 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1EKDDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 23:03:53 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
X-AuditID: cbfee61a-b7c84ae000006ee6-c3-4dc9fc915714
Date: Wed, 11 May 2011 12:03:43 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH] touchscreen: check kzalloc memory for data first
In-reply-to: <BANLkTi=yWrPiz9Wp0H46at4NVfMSJ8n1uw@mail.gmail.com>
To: Steven Liu <lingjiujianke@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, liuqi@thunderst.com
Message-id: <4DC9FC8F.7020305@samsung.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Thunderbird/3.1.7
References: <BANLkTi=yWrPiz9Wp0H46at4NVfMSJ8n1uw@mail.gmail.com>
X-OriginalArrivalTime: 11 May 2011 03:03:45.0754 (UTC)
 FILETIME=[0AC4CBA0:01CC0F88]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven.

On 2011-05-11 오전 11:23, Steven Liu wrote:
> Hi Joonyoung Shim ,
>
>              Can this patch be fixed in?
>
>
> if kzalloc memroy for data was faild, it will multi free data
> memory space. so check the data memory first, is it kzalloc faild
> for data, it should goto end and do nothing.
>

Hmm, I don't think this patch needs. If you see the codes, there is no
multi free data memory, just free data and input_dev. This both free
are no problem because when the pointer is NULL, no operation is
perfomed in the free function.

Thanks.
