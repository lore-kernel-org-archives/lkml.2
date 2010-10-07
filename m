Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab0JGXtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:49:01 -0400
Received: from ocean.emcraft.com ([213.221.7.182]:57547 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0JGXtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:49:00 -0400
Message-ID: <4CAE5C6D.6000808@emcraft.com>
Date: Fri, 08 Oct 2010 03:49:01 +0400
From: Ilya Yanok <yanok@emcraft.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ru; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Vladimir K'" <vlad@emcraft.com>, Wolfgang Denk <wd@denx.de>
Subject: Re: [RFC] CONFIG_NET_DMA  can hang the system if DMA engine driver
 uses tasklets
References: <4CAE5445.4020106@emcraft.com> <4CAE58B5.1030901@intel.com>
In-Reply-To: <4CAE58B5.1030901@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

08.10.2010 3:33, Dan Williams wrote:
>> 3. Try to free the descriptors not only from tasklet but also from the
>> place they get requested.
>
> This is what ioatdma and iop-adma do i.e. process descriptor reclaim
> from the allocation failure path. For example in ioat2_check_space_lock():

Thanks for the quick answer! I'll fix the mpc512x_dma driver then.

Regards, Ilya.
