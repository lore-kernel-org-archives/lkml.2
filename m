Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab2KEKnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:43:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42239 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2KEKnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:43:41 -0500
MIME-Version: 1.0
In-Reply-To: <509792FB.1080604@gmail.com>
References: <509430C3.9090401@gmail.com>
	<509792FB.1080604@gmail.com>
Date: Mon, 5 Nov 2012 11:43:39 +0100
Message-ID: <CAFLxGvx-Q3Ye4obNnVbEbEpG8YwecKxEXU0wg11Q1kDrOA1X9w@mail.gmail.com>
Subject: Re: IMX257 framebuffer problem
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Stefan Koch <stefan.koch10@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 11:20 AM, Stefan Koch <stefan.koch10@gmail.com> wrote:
>> What could be the problem?

Find out what exactly is happening after calling add_imx_fb().
Call it a bit later so that you can see everything on the UART.
You can hack the call into init/main.c or something else...

-- 
Thanks,
//richard
