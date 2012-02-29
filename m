Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2B2UiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:38:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2B2UiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:38:20 -0500
Date: Wed, 29 Feb 2012 12:38:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH resend] mm: drain percpu lru add/rotate page-vectors on
 cpu hot-unplug
Message-Id: <20120229123818.61a61e9d.akpm@linux-foundation.org>
In-Reply-To: <20120228193620.32063.83425.stgit@zurg>
References: <20120228193620.32063.83425.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 23:40:45 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This cpu hotplug hook was accidentally removed in commit v2.6.30-rc4-18-g00a62ce
> ("mm: fix Committed_AS underflow on large NR_CPUS environment")

That was a long time ago - maybe we should leave it removed ;) I mean,
did this bug(?) have any visible effect?  If so, what was that effect?

IOW, the changelog didn't give anyone any reason to apply the patch to
anything!
