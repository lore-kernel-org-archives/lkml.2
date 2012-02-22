Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2BVNpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:45:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab2BVNpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:45:14 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH 34/36] block: implement bio_associate_current()
References: <1329875223-5102-1-git-send-email-tj@kernel.org>
	<1329875223-5102-35-git-send-email-tj@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 22 Feb 2012 08:45:02 -0500
In-Reply-To: <1329875223-5102-35-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Tue, 21 Feb 2012 17:47:01 -0800")
Message-ID: <x49linvyobl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> -v2: #ifdef CONFIG_BLK_CGROUP added around bio->bi_ioc dereference in
>      rq_ioc() to fix build breakage.

This is useful for cfq without blk cgroups as well, right?  Why have you
limited the scope like this?

Cheers,
Jeff
