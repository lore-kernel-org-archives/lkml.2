Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0IWVif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:38:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919Ab0IWVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:38:34 -0400
Date: Thu, 23 Sep 2010 14:37:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cdahlin@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] inotify_add_watch_at
Message-Id: <20100923143730.6b612a0a.akpm@linux-foundation.org>
In-Reply-To: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
References: <1285132618-31573-1-git-send-email-cdahlin@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 01:16:55 -0400
cdahlin@redhat.com wrote:

> I had use for this system call recently when I was trying to monitor a lockfile
> to see when it disappeared. Its semantics are as you'd expect; it has over
> inotify_add_watch what openat(2) has over open(2).
> 
> Currently compile-tested only, and missing hookups for arches I don't have
> around.

When adding new syscalls it's nice to include a testcase for the arch
maintainers, please.  Paste it into the changelog, add a link to it,
etc.

Also please cc linux-arch@vger.kernel.org so they find out about it
earlier.
