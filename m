Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761044Ab0J0MBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:01:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:52334 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0J0MBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:01:06 -0400
Message-ID: <4CC813DB.4090001@windriver.com>
Date: Wed, 27 Oct 2010 06:58:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Rabin Vincent <rabin@rab.in>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH] kgdb,arm: fix register dump
References: <1288115392-23383-1-git-send-email-rabin@rab.in>
In-Reply-To: <1288115392-23383-1-git-send-email-rabin@rab.in>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 11:58:20.0414 (UTC) FILETIME=[3FCA81E0:01CB75CE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2010 12:49 PM, Rabin Vincent wrote:
> DBG_MAX_REG_NUM incorrectly had the number of indices in the GDB regs
> array rather than the number of registers, leading to an oops when the
> "rd" command is used in KDB.
>
>   

Thanks!

I have queued this to be merged in 2.6.37.

Cheers,
Jason.
