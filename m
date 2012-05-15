Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965077Ab2EOPSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:18:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44384 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964830Ab2EOPSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:18:18 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <4FB06604.5060608@kernel.org>
References: <1336027242-372-4-git-send-email-minchan@kernel.org>
	<4FA28EFD.5070002@vflare.org>
	<4FA33E89.6080206@kernel.org>
	<alpine.LFD.2.02.1205071038090.2851@tux.localdomain>
	<4FA7C2BC.2090400@vflare.org>
	<4FA87837.3050208@kernel.org>
	<731b6638-8c8c-4381-a00f-4ecd5a0e91ae@default>
	<4FA9C127.5020908@kernel.org>
	<d8fb8c73-0fd4-47c6-a9bb-ba3573569d63@default>
	<4FAC5C87.3060504@kernel.org>
	<20120511190643.GB3785@phenom.dumpdata.com>
	<4FB06604.5060608@kernel.org>
Date: Tue, 15 May 2012 11:18:17 -0400
X-Google-Sender-Auth: E7HXADhOEv6i43CPO2Rf-PrEr0k
Message-ID: <CAPbh3ruaPQ+6s9t4KULYr2TdTUhUQNfQhFUt=C2jpvAvh+QTsQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I think it's not urgent than zs_handle mess.
>>
>> I am having a hard time parsing that. Are you saying that
>> this is not as important as the zs_handle fixup? I think
>> that is what you meant, but what to make sure.
>
>
> Yes. I think zs_hande fixup is top priority for me than any other stuff I pointed out.

What else is should we put on the TODO?
