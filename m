Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158Ab2EQHQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 03:16:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52924 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920Ab2EQHQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 03:16:16 -0400
Message-ID: <4FB4B18A.8020803@gmail.com>
Date: Thu, 17 May 2012 16:06:34 +0800
From: Xiao Jiang <jgq516@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: steve.glendinning@smsc.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] smsc95xx: add FLAG_POINTTOPOINT flag for driver_info
References: <1337155302-26244-1-git-send-email-jgq516@gmail.com> <4FB3A74E.4060303@mvista.com>
In-Reply-To: <4FB3A74E.4060303@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.
>
> On 16-05-2012 12:01, jgq516@gmail.com wrote:
>
>> From: Xiao Jiang<jgq516@gmail.com>
>
>> commit c26134 introduced FLAG_POINTTOPOINT flag for USB ethernet devices
>
>    Please also specify that commit's summary in parens.
Thanks, will add the summary if this patch does make sense.

Regards,
Xiao
>
>> which possibly use "usb%d" names, add this flag to make sure pandaboard
>> can mount nfs with smsc95xx NIC.
>
>> Signed-off-by: Xiao Jiang<jgq516@gmail.com>
>
> WBR, Sergei

