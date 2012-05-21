Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab2EUKte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 06:49:34 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42049 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2EUKtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 06:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205201426430.10189@chino.kir.corp.google.com>
References: <1337507659-14740-1-git-send-email-nasirabed+kernel@gmail.com>
	<alpine.DEB.2.00.1205201328170.10189@chino.kir.corp.google.com>
	<1337546284.31503.5.camel@joe2Laptop>
	<1337547996.31503.8.camel@joe2Laptop>
	<alpine.DEB.2.00.1205201426430.10189@chino.kir.corp.google.com>
Date: Mon, 21 May 2012 12:49:33 +0200
Message-ID: <CAMXkaZE_D7wFZ1PzZgwG8hL7wqvLFaP=M=9OAP08fz7zj2dBUw@mail.gmail.com>
Subject: Re: [PATCH] Staging: android: alarm: Rename pr_alarm to alarm_dbg
From: Nasir Abed <nasirabed@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        swetland@google.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't:
[PATCH] Staging: android: alarm: Rename pr_alarm to alarm_dbg
Be:
[PATCH] Staging: android: alarm-dev: Rename pr_alarm to alarm_dbg

Cheers,

Nasir Abed


On Sun, May 20, 2012 at 11:26 PM, David Rientjes <rientjes@google.com> wrote:
> On Sun, 20 May 2012, Joe Perches wrote:
>
>> Rename a macro to make it explicit it's for debugging.
>>
>> Use %s: __func__ instead of embedding function names.
>> Coalesce formats, align arguments.
>>
>> Signed-off-by: Joe Perches <joe@perches.com>
>
> Acked-by: David Rientjes <rientjes@google.com>
