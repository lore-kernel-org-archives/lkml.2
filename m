Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab2GYHzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 03:55:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10213 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2GYHzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 03:55:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6782"; a="214218101"
Message-ID: <500FA653.7090808@codeaurora.org>
Date: Wed, 25 Jul 2012 00:54:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 07/13] driver core: firmware loader: introduce cache_firmware
 and uncache_firmware
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com> <1343149213-10160-8-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1343149213-10160-8-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/2012 10:00 AM, Ming Lei wrote:
>
> +
> +int cache_firmware(const char *name)
> +{
> +	return -ENOENT;
> +}
> +
> +int uncache_firmware(const char *name)
> +{
> +	return -EINVAL;
> +}

These stubs need to be static inline to avoid compiler warnings.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

