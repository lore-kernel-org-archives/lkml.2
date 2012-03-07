Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab2CGPhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:37:18 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47502 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758073Ab2CGPhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:37:17 -0500
Message-ID: <4F5780A2.2040402@gmail.com>
Date: Wed, 07 Mar 2012 23:37:06 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/07/2012 10:51 PM, Chen, Dennis (SRDC SW) wrote:

Before we are going into tech details...

> 1. Narrow down the granularity of mutex_lock/ mutex_unlock
> 2. Replace some unnecessary mutex_lock/mutex_unlock pairs with RCU
> 3. Refine the consistent calling style of RCU functioan

Please split the patch into three patches.

>
> --- module.ori.c        2012-03-07 19:59:07.890900147 +0800
> +++ module.c    2012-03-07 22:12:44.982738729 +0800

The patch is not correctly generated, check 
Documentation/SubmittingPatches for more info.

Thanks,
