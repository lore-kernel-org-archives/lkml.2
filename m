Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685Ab2FNLI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:08:56 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51326 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755450Ab2FNLIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <1339669606-9579-1-git-send-email-balbi@ti.com>
References: <1339669606-9579-1-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:38:34 +0530
Message-ID: <CAMQu2gyPTJNNV5T4jN4eD+sz2e_qYqG0HY9R+ByBw_mDY=ANGA@mail.gmail.com>
Subject: Re: [PATCH] rtc: twl: add missing IRQF_ONESHOT
To: Felipe Balbi <balbi@ti.com>
Cc: a.zummo@towertech.it,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 3:56 PM, Felipe Balbi <balbi@ti.com> wrote:
> This patch gets rid of the following warning:
>
> [    2.825378] genirq: Threaded irq requested with \
>        handler=NULL and !ONESHOT for irq 363
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

Ming Lei has posted a similar fix earlier [1]

Regards
Santosh
http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/00668.html
