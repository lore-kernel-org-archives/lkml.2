Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab0JOCP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 22:15:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:43677 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab0JOCPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 22:15:54 -0400
Date: Fri, 15 Oct 2010 10:15:46 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: Tom Brown <sa212+emis@cyconix.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question: how to copy to user space from a tasklet
Message-ID: <20101015021546.GA15339@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <4CB6DEC4.4040408@cyconix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CB6DEC4.4040408@cyconix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Oct 2010 02:15:48.0245 (UTC) FILETIME=[E1B7C450:01CB6C0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 11:43:16AM +0100, Tom Brown wrote:
> [Sorry to have to ask this here - I can't find any driver-specific
> newsgroup or mailing lists - are there any??]
> 
> I have a driver which needs to copy device data direct to user space
> from a tasklet. I need to do this because the device is continuously
> DMA'ing into user space, with no user intervention, so the user
> isn't waiting for data. In other words, I don't have any
> user-associated process to wake up.
> 
> This means that I have to somehow copy the data directly to the user
> from the tasklet, without sleeping, and without direct access to
> user context. Can someone tell me how to do this?

Are you seeking for probe_kernel_read/write(include/linux/uaccess.h)?

Thanks,
Yong

> 
> Thanks
> 
> Tom
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
