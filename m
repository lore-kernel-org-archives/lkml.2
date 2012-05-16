Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967228Ab2EPNLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 09:11:09 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47766 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966161Ab2EPNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 09:11:07 -0400
Message-ID: <4FB3A74E.4060303@mvista.com>
Date: Wed, 16 May 2012 17:10:38 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: jgq516@gmail.com
CC: steve.glendinning@smsc.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] smsc95xx: add FLAG_POINTTOPOINT flag for driver_info
References: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
In-Reply-To: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-05-2012 12:01, jgq516@gmail.com wrote:

> From: Xiao Jiang<jgq516@gmail.com>

> commit c26134 introduced FLAG_POINTTOPOINT flag for USB ethernet devices

    Please also specify that commit's summary in parens.

> which possibly use "usb%d" names, add this flag to make sure pandaboard
> can mount nfs with smsc95xx NIC.

> Signed-off-by: Xiao Jiang<jgq516@gmail.com>

WBR, Sergei
