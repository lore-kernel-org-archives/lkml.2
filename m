Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2E3SQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 14:16:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab2E3SQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 14:16:13 -0400
Date: Wed, 30 May 2012 20:14:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Pavel Emelyanov <xemul@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] pidns: premature pid_ns_release_proc() fixes
Message-ID: <20120530181429.GA19989@redhat.com>
References: <20120530175745.GA19327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530175745.GA19327@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn. Forgot to add lkml, resending. Sorry for spam.

On 05/30, Oleg Nesterov wrote:
>
> Hello,
>
> Our discussion was a bit confusing, I am resending the pidns fixes,
>
> 	1/2 - Eric's patch (was recently "to-be-updated") + cleanups from me
>
> 	2/2 - another fix, acked by Eric.
>
>               Cough. checkpatch complains about line over 80 characters.
> 	      Can we sometime ignore this warning? Any change I tried
> 	      makes the code less readable.
>
> Oleg.

