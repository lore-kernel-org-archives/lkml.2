Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0JOH6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 03:58:37 -0400
Received: from mail.renesas.com ([202.234.163.13]:35546 "EHLO
	mail06.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677Ab0JOH6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 03:58:36 -0400
X-AuditID: ac14038a-00000009000001f2-25-4cb809997f46
Date: Fri, 15 Oct 2010 16:58:17 +0900
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: Re: [PATCH 3/3] USB: ohci-sh - use resource_size instead of defining
 its own resource_len macro
In-reply-to: <1287120564.20429.5.camel@mola>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Message-id: <4CB80999.3050300@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9)
 Gecko/20100915 Thunderbird/3.1.4
References: <1287120381.20429.1.camel@mola> <1287120564.20429.5.camel@mola>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

2010/10/15 14:29, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/usb/host/ohci-sh.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Thank you very much for your patch.
Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Thanks,
Yoshihiro Shimoda
