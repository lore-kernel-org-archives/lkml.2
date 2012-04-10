Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab2DJTRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:17:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2DJTRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:17:44 -0400
Date: Tue, 10 Apr 2012 12:17:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, dhowells@redhat.com, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        criu@openvz.org, mtk.manpages@gmail.com
Subject: Re: [PATCH 4/4] test: IPC message queue migration test
Message-Id: <20120410121742.3c0eb61c.akpm@linux-foundation.org>
In-Reply-To: <20120409175419.8358.18639.stgit@localhost6.localdomain6>
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6>
	<20120409175419.8358.18639.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Apr 2012 21:54:19 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> This test is a part of CRIU development test suit.
> 
> ---
>  msgque.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Neat.  Can you please integrate this into tools/testing/selftests? 
You'll need to decide whether it should be under
tools/testing/selftests/checkpoint-restore or
tools/testing/selftests/ipc.  Perhaps the former, as you guys will
hopefully have more userspace test harnesses?

Also, I suggest that I throw away the current
c-r-ipc-message-queue-stealing-feature-introduced.patch.  Please fold
all the changes you've made to that patch into a single patch and
resend the whole series.  I guess that will be two patches:
c-r-ipc-message-queue-stealing-feature-introduced-v2 and the
tools/testing/selftests/ addition.

