Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab0HKIDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:03:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:36156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab0HKIDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:03:32 -0400
Message-ID: <4C6258FC.4060706@kernel.org>
Date: Wed, 11 Aug 2010 10:02:04 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix a mismatch between code and comment
References: <1281493159-2574-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281493159-2574-1-git-send-email-namhyung@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 11 Aug 2010 08:03:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2010 04:19 AM, Namhyung Kim wrote:
> When pcpu_build_alloc_info() searches best_upa value, it ignores current value
> if the number of waste units exceeds 1/3 of the number of total cpus. But the
> comment on the code says that it will ignore if wastage is over 25%.
> Modify the comment.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Applied to percpu#for-linus.  Thanks.

-- 
tejun
