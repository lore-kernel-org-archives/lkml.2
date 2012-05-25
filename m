Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab2EYQBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:01:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675Ab2EYQBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:01:13 -0400
Date: Fri, 25 May 2012 17:59:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [PATCH -mm 0/1] pidns: find_new_reaper() can no longer switch to
	init_pid_ns.child_reaper
Message-ID: <20120525155941.GA16885@redhat.com>
References: <878vgrsv7q.fsf@xmission.com> <20120517170015.GA12436@redhat.com> <87d3628oqa.fsf@xmission.com> <20120518123911.GA417@redhat.com> <87zk95kper.fsf@xmission.com> <20120521124414.GA20391@redhat.com> <87d35x5ank.fsf_-_@xmission.com> <20120522122315.c3f2118c.akpm@linux-foundation.org> <20120523145239.GA20378@redhat.com> <20120525151526.GA13111@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525151526.GA13111@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25, Oleg Nesterov wrote:
>
> So. Eric, Andrew, will you agree with this cleanup on top of
> pidns-guarantee-that-the-pidns-init-will-be-the-last-pidns-process-reaped-v2-fix.patch
> ?

And I think we need another subtle fix.

Compile-only tested, please review.

Oleg.

