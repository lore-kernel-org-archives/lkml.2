Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab2LIAjO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 19:39:14 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42751 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713Ab2LIAjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 19:39:12 -0500
Message-ID: <50C3DBF6.2080103@gmail.com>
Date: Sun, 09 Dec 2012 01:31:50 +0100
From: Cyril Roelandt <tipecaml@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        florian.c.schilhabel@googlemail.com, gregkh@linuxfoundation.org,
        kernel-janitors@vger.kernel.org, yongjun_wei@trendmicro.com.cn,
        marcos.souza.org@gmail.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH] staging: rtl8712: avoid a useless call to memset().
References: <1354670522-27144-1-git-send-email-tipecaml@gmail.com> <20121205071156.GL6568@mwanda>
In-Reply-To: <20121205071156.GL6568@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2012 08:11 AM, Dan Carpenter wrote:
> On Wed, Dec 05, 2012 at 02:22:02AM +0100, Cyril Roelandt wrote:
>> In r8711_wx_get_wap(), make sure we do not call memcpy() on a memory area that
>> has just been zeroed by a call to memset().
>>
>
> I look at it like the original code is fine.  Your version is also
> fine but is it worth the churn?  Also the curly braces are not
> needed.
>

Sorry about the braces.

I just thought the code would be easier to understand this way, but it's 
probably OK to leave it as it currently is too.

WBR,
Cyril Roelandt.
