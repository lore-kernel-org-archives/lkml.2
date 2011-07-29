Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1G2RT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 13:19:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33012 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1G2RT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 13:19:28 -0400
MIME-Version: 1.0
In-Reply-To: <20110729.101515.1435434309123620862.davem@davemloft.net>
References: <1311959479.2242.41.camel@vivanov>
	<20110729.101515.1435434309123620862.davem@davemloft.net>
Date: Fri, 29 Jul 2011 20:19:26 +0300
Message-ID: <CAGTPOqdTxkFHxp-qNAMjg_YV91ZF2Fxze-HyV-TGsoF_r5ZyVQ@mail.gmail.com>
Subject: Re: [PATCH] net: xprt.c: htmldocs warning correction
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: David Miller <davem@davemloft.net>, Randy Dunlap <rdunlap@xenotime.net>
Cc: Trond.Myklebust@netapp.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 29, 2011 at 8:15 PM, David Miller <davem@davemloft.net> wrote:
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Fri, 29 Jul 2011 20:11:19 +0300
>
>> Add description for parameter 'xprt'.
>>
>> Warning(/net/sunrpc/xprt.c:196): No description found for parameter 'xprt'
>>
>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>
> There is already a fix for this from Randy Dunlap in my networking
> GIT tree.
>

OK, I found two other warning correction patches from Randy in list
but not this one. Seems like I missed it.

Anyway, thanks.

Vitaliy
