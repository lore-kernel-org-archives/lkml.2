Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187Ab2IMPH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:07:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56084 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758114Ab2IMPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:07:25 -0400
Date: Thu, 13 Sep 2012 17:07:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf record: Change error message on failure
Message-ID: <20120913150720.GA27411@gmail.com>
References: <1347531654-16024-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347531654-16024-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Only report
> 
>  No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> if the syscall fails with ENOSYS. In other cases CONFIG_PERF_EVENTS is
> set and might confuse users. The default message is now:
> 
>  Not all events could be opened.

Indeed, and it would be nice to be even less passive-aggressive 
and figure out and display the exact error condition?

Thanks,

	Ingo
