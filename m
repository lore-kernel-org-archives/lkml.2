Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab2ADBvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 20:51:05 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:49815 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2ADBvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 20:51:03 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Tue, 03 Jan 2012 17:39:07 -0800
Message-ID: <4F03B085.6000101@synaptics.com>
Date: Tue, 3 Jan 2012 17:51:01 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 00/11] input: Synaptics RMI4 Touchscreen Driver
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com> <CACRpkdbcK9SGtQf9g55h_PGPenrvc9kxPYfZXNV1-4K8NvdAgg@mail.gmail.com>
In-Reply-To: <CACRpkdbcK9SGtQf9g55h_PGPenrvc9kxPYfZXNV1-4K8NvdAgg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2012 05:51 AM, Linus Walleij wrote:
> On Thu, Dec 22, 2011 at 3:09 AM, Christopher Heiny<cheiny@synaptics.com>  wrote:
>
>> This patch implements a driver supporting Synaptics ClearPad and other
>> touchscreen sensors that use the RMI4 protocol, as defined here:
>
> This looks like a fundamental rewrite an huge improvement over the
> previous RMI4 patches, good job!
>
> I am not very deeply versed in the input subsystem but overall it looks
> good to me, nice structure etc. I hope to be able to get back to a detailed
> review and per-patch Acked-by:s ASAP.

Thanks!

We realized we were in a red queen's race by trying to both implement 
customer requests and restructure the system at the same time, so 
contracted Unixphere to help with the restructure.  We think the result 
was pretty good, and it's nice to hear compliments.

We'll look forward to your input after the detailed review.

					Thanks again,
						Chris
