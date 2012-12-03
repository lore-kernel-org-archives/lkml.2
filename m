Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2LCRGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:06:45 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54307 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000Ab2LCRGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:06:44 -0500
Message-ID: <50BCDBD6.2020003@linaro.org>
Date: Mon, 03 Dec 2012 09:05:26 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Zhangfei Gao <zhangfei.gao@linaro.org>
CC: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] merge_config.sh: Add option to specify output dir
References: <50B82DA7.8030404@linaro.org> <1354520170-12844-1-git-send-email-zhangfei.gao@linaro.org>
In-Reply-To: <1354520170-12844-1-git-send-email-zhangfei.gao@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120317-5806-0000-0000-00001C7D6794
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2012 11:36 PM, Zhangfei Gao wrote:
> Provide a -O option to specify dir to put generated .config
> Then merge_config.sh does not need to be copied to target dir,
> for easy re-usage in other script
>
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Tested-by: Jon Medhurst (Tixy) <tixy@linaro.org>
Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john

