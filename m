Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161530Ab2GLVRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:17:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26464 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911Ab2GLVRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:17:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6770"; a="207713083"
Message-ID: <4FFF3EF0.3020000@codeaurora.org>
Date: Thu, 12 Jul 2012 14:17:36 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eldad Zack <eldad@fogrefinery.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 1/2] kstrto*: add documentation
References: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com>
In-Reply-To: <1342126395-18055-1-git-send-email-eldad@fogrefinery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/12 13:53, Eldad Zack wrote:
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index e07f5e0..582df0f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -220,6 +220,16 @@ int __must_check _kstrtol(const char *s, unsigned int base, long *res);
>  
>  int __must_check kstrtoull(const char *s, unsigned int base, unsigned long long *res);
>  int __must_check kstrtoll(const char *s, unsigned int base, long long *res);
> +
> +/**
> + * kstrtoul - convert a string to an unsigned long

Aren't function names supposed to have () after them in kernel doc?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

