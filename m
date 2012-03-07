Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2CGEOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:14:51 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55438 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757241Ab2CGEOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:14:50 -0500
Message-ID: <4F56E0AC.8070501@gmail.com>
Date: Wed, 07 Mar 2012 12:14:36 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Barry Song <Barry.Song@csr.com>
CC: m.szyprowski@samsung.com, mina86@mina86.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH v3] MM: CMA: add a simple kernel module as the helper
 to test CMA
References: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
In-Reply-To: <1331090098-25097-1-git-send-email-Barry.Song@csr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2012 11:14 AM, Barry Song wrote:
> From: Barry Song<Baohua.Song@csr.com>
>
> Any write request to /dev/cma_test will let the module to allocate memory from
> CMA, for example:
>
> 1st time
> $ echo 1024>  /dev/cma_test
> will require cma_test to request 1MB(1024KB)
> 2nd time
> $ echo 2048>  /dev/cma_test
> will require cma_test to request 2MB(2048KB)
>
> Any read request to /dev/cma_test will let the module to free the 1st valid
> memory from CMA, for example:
>
> 1st time
> $ cat /dev/cma_test
> will require cma_test to free the 1MB allocated in the first write request
> 2nd time
> $ cat /dev/cma_test
> will require cma_test to free the 2MB allocated in the second write request

Any reason why using /dev not /proc or /sys?
