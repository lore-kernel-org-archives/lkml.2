Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2JAUzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:55:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2JAUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:55:47 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 04/15] cfq-iosched: Rename few functions related to selecting workload
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-5-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 16:55:43 -0400
In-Reply-To: <1349119976-26837-5-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:45 -0400")
Message-ID: <x49ehlhj4j4.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> choose_st() selects/sets both wl_class and wl_type.  Rename it to
> choose_wl_class_and_type() to make it very clear.
>
> cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
> it with choose_st(). So rename it to cfq_choose_wl_type() to make
> it clear what does it do.
>
> Just renaming. No functionality change.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

No objections.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
