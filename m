Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab2IYGVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:21:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55983 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2IYGVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:21:01 -0400
Message-ID: <50614D4C.6080509@wwwdotorg.org>
Date: Tue, 25 Sep 2012 00:21:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: akpm@linux-foundation.org, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH v2] rtc: tps65910: Use platform_get_irq to get RTC irq
 details
References: <1348550964-32534-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1348550964-32534-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 11:29 PM, Venu Byravarasu wrote:
> As RTC driver needs only irq number from platform data,
> using platform_get_irq(), instead of generic dev_get_platdata().

This seems fine to me now.

However, it'd be useful to post all the patches related to this issue at
one time, so we can get a clear picture of everything that goes into
fixing the problem.
