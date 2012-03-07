Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787Ab2CGWWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:22:05 -0500
Received: from fifo99.com ([67.223.236.141]:60134 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030754Ab2CGWWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:22:01 -0500
Message-ID: <4F57DF7F.9010700@fifo99.com>
Date: Wed, 07 Mar 2012 14:21:51 -0800
From: Daniel Walker <dwalker@fifo99.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 07/13] android: persistent_ram: refactor ecc support
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org> <1331157503-3413-8-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1331157503-3413-8-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 01:58 PM, John Stultz wrote:
> From: Colin Cross<ccross@android.com>
>
> Remove CONFIG_ANDROID_RAM_CONSOLE_ERROR_CORRECTION and related
>   #ifdefs.  Also allow persistent ram zones without ecc enabled.
> For some use cases, like the data portion of the upcoming
> persistent_vars patches, or a persistent ftrace ringbuffer,
> ecc on every update is too expensive.
>
> CC: Greg KH<gregkh@linuxfoundation.org>
> CC: Android Kernel Team<kernel-team@android.com>
> Change-Id: Ia710344b6c54fe252e0a87353955e063b3c054ab


Seems like you would want to drop the Change-Id: regardless of staging, 
it doesn't carry any meaning outside of Google.

Daniel
