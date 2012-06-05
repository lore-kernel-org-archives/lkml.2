Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041Ab2FEMAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:00:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42125 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab2FEMAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:00:50 -0400
Message-ID: <4FCDF4C8.2090403@mvista.com>
Date: Tue, 05 Jun 2012 16:00:08 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH 1/5] usb: musb: move work_struct(otg_notifier_work) from
 core to omap glue
References: <1338889118-10032-1-git-send-email-kishon@ti.com> <1338889118-10032-2-git-send-email-kishon@ti.com>
In-Reply-To: <1338889118-10032-2-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-06-2012 13:38, Kishon Vijay Abraham I wrote:

> Commit 712d8e

    Please also specify that commit's summary in parens.

> fixed pm_runtime calls while atomic by using a work queue.
> While the issue and the work queue implementation is specific to omap
> (omap2430.c), the work_struct is defined as a member of struct musb
> (musb_core.h). Hence moved the work_struct from musb_core to omap
> glue.

> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>

WBR, Sergei
