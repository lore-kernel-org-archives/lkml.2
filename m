Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2JAUvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:51:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab2JAUvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:51:06 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 01/15] cfq-iosched: Properly name all references to IO class
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-2-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 16:51:02 -0400
In-Reply-To: <1349119976-26837-2-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:42 -0400")
Message-ID: <x49mx05j4qx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Currently CFQ has three IO classes, RT, BE and IDLE. At many a places we
> are calling workloads belonging to these classes as "prio". This gets
> very confusing as one starts to associate it with ioprio.
>
> So this patch just does bunch of renaming so that reading code becomes
> easier. All reference to RT, BE and IDLE workload are done using keyword
> "class" and all references to subclass, SYNC, SYNC-IDLE, ASYNC are made
> using keyword "type".
>
> This makes me feel much better while I am reading the code. There is no
> functionality change due to this patch.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Thank you!

Acked-by: Jeff Moyer <jmoyer@redhat.com>
