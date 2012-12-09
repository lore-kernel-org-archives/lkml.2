Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab2LIRWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 12:22:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2LIRWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 12:22:53 -0500
Date: Sun, 9 Dec 2012 18:22:51 +0100
From: Michal Marek <mmarek@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH] merge_config.sh: Add option to specify output dir
Message-ID: <20121209172251.GB29331@pobox.suse.cz>
References: <50B82DA7.8030404@linaro.org> <1354520170-12844-1-git-send-email-zhangfei.gao@linaro.org> <50BCDBD6.2020003@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BCDBD6.2020003@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 09:05:26AM -0800, John Stultz wrote:
> On 12/02/2012 11:36 PM, Zhangfei Gao wrote:
>> Provide a -O option to specify dir to put generated .config
>> Then merge_config.sh does not need to be copied to target dir,
>> for easy re-usage in other script
>>
>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>> Tested-by: Jon Medhurst (Tixy) <tixy@linaro.org>
> Acked-by: John Stultz <john.stultz@linaro.org>

Applied to kbuild.git#kconfig, thanks.

Michal
