Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2K2J1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 04:27:09 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35407 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2K2J1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 04:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121129092308.GT2013@gmail.com>
References: <d1f012d7bb2835f696fc100073f2eb16d9f6204d.1354128258.git.viresh.kumar@linaro.org>
	<eb65ded18560f902b0713d9df57c43e07704b5ec.1354128258.git.viresh.kumar@linaro.org>
	<20121129092308.GT2013@gmail.com>
Date: Thu, 29 Nov 2012 14:57:05 +0530
Message-ID: <CAKohpomw7yn-wj==qscuQ5j2FGv=Ks3RU9py=NWUnnT0_cK1aA@mail.gmail.com>
Subject: Re: [PATCH V4 Resend 3/3] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: sameo@linux.intel.com, grant.likely@secretlab.ca,
        rabin.vincent@stericsson.com, shiraz.hashim@st.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, linus.walleij@linaro.org,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 November 2012 14:53, Lee Jones <lee.jones@linaro.org> wrote:
>> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
>> +     /*
>> +      * Distinct names of same cell-type within multiple instances of stmpe
>> +      * will be guaranteed by DT.
>> +      */
>> +     pdata->id = -1;
>
> And what if we're not booting with DT?

Then it is responsibility of code creating platform data for stmpe to fill
it appropriately. i.e. If there is only one instance of stmpe on board, then
better pass it as -1, else start counting.
