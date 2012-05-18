Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2ERQOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:14:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239Ab2ERQOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:14:41 -0400
Date: Fri, 18 May 2012 17:14:23 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: koverstreet@google.com
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, agk@redhat.com,
        Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] [PATCH 01/13] block: Generalized bio pool freeing
Message-ID: <20120518161423.GI29330@agk-dp.fab.redhat.com>
Mail-Followup-To: koverstreet@google.com, Tejun Heo <tj@kernel.org>,
	axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	agk@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>
References: <cover.1337308722.git.koverstreet@google.com> <ea774fea2a27c9f1028a12ce31a7ee5e5517bef4.1337308722.git.koverstreet@google.com> <20120518155538.GA19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518155538.GA19388@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This dance should come out of clone_endio() and __map_bio() too?

        bio->bi_private = md->bs;

Alasdair

