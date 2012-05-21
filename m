Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab2EUSZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 14:25:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805Ab2EUSZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 14:25:45 -0400
Date: Mon, 21 May 2012 20:24:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: call_usermodehelper && check_hung_uninterruptible_tasks
Message-ID: <20120521182417.GA4297@redhat.com>
References: <4F6A93F5.1070202@panasas.com> <201203241028.IGJ09825.MtOVFHFJQSLOFO@I-love.SAKURA.ne.jp> <4F6D35F0.2020808@panasas.com> <20120323200028.fadf49f8.akpm@linux-foundation.org> <20120324145308.GA10023@redhat.com> <201205191121.BIF57837.FHFOtMOLJQSOFV@I-love.SAKURA.ne.jp> <4FB7170F.7070807@panasas.com> <20120521170135.GA31803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521170135.GA31803@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21, Oleg Nesterov wrote:
>
> But there is another problem, wait_for_completion/wait_for_completion_killable
> are not freezer-friendly. Perhaps something like the patch below? Just in case,
> it should silence check_hung_uninterruptible_tasks() as well.

Ah, please ignore. I forgot about freeze_processes()->usermodehelper_disable().

Oleg.

