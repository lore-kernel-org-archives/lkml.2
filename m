Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2DPWLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:11:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2DPWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:11:37 -0400
Date: Mon, 16 Apr 2012 15:11:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: serge.hallyn@canonical.com, criu@openvz.org, arnd@arndb.de,
        lucas.demarchi@profusion.mobi, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, mtk.manpages@gmail.com
Subject: Re: [PATCH v2 2/2] IPC: selftest tor new MSG_PEEK_ALL flag for
 msgrcv()
Message-Id: <20120416151130.732cd0d0.akpm@linux-foundation.org>
In-Reply-To: <20120416140613.653.89845.stgit@localhost6.localdomain6>
References: <20120416140235.653.36996.stgit@localhost6.localdomain6>
	<20120416140613.653.89845.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 18:06:13 +0400
Stanislav Kinsbursky <skinsbursky@parallels.com> wrote:

> This test send two messages, then peek them and check, that they are equal to
> original messages. Then it receives messages and check once more to make sure,
> that messages are not corrupted or lost after peek operation.
> 
> ---

Missing signed-off-by.  I added your s-o-b to my copy of the changelog.
