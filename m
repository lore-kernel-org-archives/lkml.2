Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759027Ab2EYXMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 19:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201Ab2EYXMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 19:12:52 -0400
Date: Sat, 26 May 2012 00:12:33 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 13/16] Make generic_make_request handle arbitrarily
	large bios
Message-ID: <20120525231232.GH5761@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
	axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
	drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
	mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-14-git-send-email-koverstreet@google.com> <20120525225852.GG5761@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525225852.GG5761@agk-dp.fab.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 11:58:52PM +0100, Alasdair G Kergon wrote:
> I think a body of *empirical* evidence should provide the justification
> for this particular change, and until such evidence is forthcoming we
> should keep the status quo.
 
What I'm trying to say is, by all means, let's continue to clean up this
patch set, but then give it some serious performance testing under
different regimes, compare it against the status quo, do whatever
tuning seems appropriate then let the results guide us.

Alasdair

