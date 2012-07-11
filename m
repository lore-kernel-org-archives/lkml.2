Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab2GKMRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:17:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54429 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab2GKMRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:17:00 -0400
Message-ID: <4FFD6E8D.4040508@mvista.com>
Date: Wed, 11 Jul 2012 16:16:13 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gerard Snitselaar <dev@snitselaar.org>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kishon@ti.com
Subject: Re: [PATCH] usb: twl6030-usb: variable otg not declared in twl6030_usbotg_irq()
 in linux-next
References: <1341901940-12277-1-git-send-email-dev@snitselaar.org>
In-Reply-To: <1341901940-12277-1-git-send-email-dev@snitselaar.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-07-2012 10:32, Gerard Snitselaar wrote:

> commit ff9cce82 added back 2 lines that were removed by commit
> c83a8542

    Please also specify the summaries of those 2 commits in parens.

> causing build of twl6030-usb to get an error due to otg being
> referenced, but not declared. This patch removes those 2 lines again
> to restore intent of commit c83a8542.

> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>

WBR, Sergei

