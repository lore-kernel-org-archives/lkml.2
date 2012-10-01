Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2JAVBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:01:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab2JAVBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:01:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 06/15] cfq-iosched: Print sync-noidle information in blktrace messages
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-7-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 17:01:07 -0400
In-Reply-To: <1349119976-26837-7-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:47 -0400")
Message-ID: <x49626tj4a4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Currently we attach a character "S" or "A" to the cfqq<pid>, to represent
> whether queues is sync or async. Add one more character "N" to represent
> whether it is sync-noidle queue or sync queue. So now three different
> type of queues will look as follows.
>
> cfq1234S   --> sync queus
> cfq1234SN  --> sync noidle queue
> cfq1234A   --> Async queue
>
> Previously S/A classification was being printed only if group scheduling
> was enabled. This patch also makes sure that this classification is
> displayed even if group idling is disabled.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

I'm assuming nobody relies on the contents of trace_message output not
changing in blktrace output.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
