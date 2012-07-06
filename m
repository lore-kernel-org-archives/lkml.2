Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab2GFIQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 04:16:42 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:45280 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751160Ab2GFIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 04:16:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArgNADWe9k9bdWOb/2dsb2JhbABFrnsiiBuBB4IYAQEEATIBBR0jAQULCxgJFg8JAwIBAgFFBg0BBwEBiAIJukSCQYh4hiYDlTeJJoZdgmGBXQ
X-IronPort-AV: E=Sophos;i="4.77,537,1336341600"; 
   d="scan'208";a="539376292"
Message-ID: <4FF69EE4.3080707@igalia.com>
Date: Fri, 06 Jul 2012 10:16:36 +0200
From: =?ISO-8859-1?Q?Miguel_G=F3mez?= <magomez@igalia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/19] Staging: xgifb: Rework some conditions in XGI_SetCRT2ModeRegs().
References: <20120706065618.GA29479@mwanda>
In-Reply-To: <20120706065618.GA29479@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Jul 05, 2012 at 04:46:00PM +0200, Miguel Gómez wrote:
>> Rework some conditions to reduce indentation and fix style warnings.
>>
>
> Instead of a do { } while(0); it would be better to just use gotos.

Point taken. I used the do-while because I didn't want to abuse gotos, 
but if there's no problem with them I'll change the patch.

I'll also change your comments in previous email about the comments ;)

Regards!

-- 
Miguel Gómez
Igalia - http://www.igalia.com


