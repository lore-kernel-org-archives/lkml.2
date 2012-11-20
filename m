Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2KTIDv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:03:51 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37230 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KTIDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:03:50 -0500
MIME-Version: 1.0
In-Reply-To: <50AB3732.5050507@samsung.com>
References: <1353388963-23761-1-git-send-email-sachin.kamat@linaro.org>
	<1353388963-23761-4-git-send-email-sachin.kamat@linaro.org>
	<50AB3732.5050507@samsung.com>
Date: Tue, 20 Nov 2012 13:33:49 +0530
Message-ID: <CAK9yfHwm=khjTN8K9rMZt2pW_fW2VStrTh=cHQbo59THakADxw@mail.gmail.com>
Subject: Re: [PATCH 3/7] extcon: Fix return value in extcon-class.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 13:24, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 11/20/2012 02:22 PM, Sachin Kamat wrote:
>> Return the value obtained from the function extcon_register_interest
>> instead of -EINVAL.
>>
>> Silences the following warning:
>> drivers/extcon/extcon-class.c:475 extcon_register_interest() info:
>> why not propagate 'obj->cable_index' from extcon_find_cable_index()
>> instead of -22?
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>
> I consolidate following two patches because of similar patch.
>
> extcon: Fix return value in extcon-class.c
> extcon: Redo: Fix return value in extcon_register_interest()

You are right. Fair enough.

>
> Thank you,
> Chanwoo Choi



-- 
With warm regards,
Sachin
