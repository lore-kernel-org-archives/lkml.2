Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab0EAGPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 02:15:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:51273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0EAGPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 02:15:47 -0400
Message-ID: <4BDBC6DA.4060901@kernel.org>
Date: Sat, 01 May 2010 08:14:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 6/8] PM: Add suspend blocking work.
References: <1272667021-21312-1-git-send-email-arve@android.com> <1272667021-21312-2-git-send-email-arve@android.com> <1272667021-21312-3-git-send-email-arve@android.com> <1272667021-21312-4-git-send-email-arve@android.com> <1272667021-21312-5-git-send-email-arve@android.com> <1272667021-21312-6-git-send-email-arve@android.com> <1272667021-21312-7-git-send-email-arve@android.com>
In-Reply-To: <1272667021-21312-7-git-send-email-arve@android.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 01 May 2010 06:14:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2010 12:36 AM, Arve Hjønnevåg wrote:
> Allow work to be queued that will block suspend while it is pending
> or executing. To get the same functionality in the calling code often
> requires a separate suspend_blocker for pending and executing work, or
> additional state and locking. This implementation does add additional
> state and locking, but this can be removed later if we add support for
> suspend blocking work to the core workqueue code.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thank you.

-- 
tejun
