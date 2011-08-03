Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1HCIcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:32:16 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34225 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1HCIcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:32:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6426"; a="107767592"
Message-ID: <4E390785.4060007@codeaurora.org>
Date: Wed, 03 Aug 2011 01:32:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: git commit id and tarball's filename mapping.
References: <201108030442.p734gwO9050751@www262.sakura.ne.jp>
In-Reply-To: <201108030442.p734gwO9050751@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/2011 9:42 PM, Tetsuo Handa wrote:
> Hello.
>
> I regularly test kernels extracted from tarballs rather than from git. I have
> problems with estimating range to "git bisect" because I can't know commit id
> as of a tarball was archived. I would appreciate if there is a mapping table
> that contains commit id and tarball's filename.
>
> 0123456789012345678901234567890123456789 linux-3.0.tar.bz2
> 1234567890123456789012345678901234567890 patch-3.0-git1.bz2
> 2345678901234567890123456789012345678901 patch-3.0-git2.bz2
> 3456789012345678901234567890123456789012 patch-3.0-git3.bz2
>   (...snipped...)
> 7890123456789012345678901234567890123456 patch-3.0-git17.bz2
> 8901234567890123456789012345678901234567 linux-3.1-rc1.tar.bz2
>

Could you use git get-tar-commit-id?

$ git get-tar-commit-id < linux-3.0.tar

It won't work for the patch ones though.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

