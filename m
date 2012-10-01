Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2JAUwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:52:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab2JAUwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:52:17 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 03/15] cfq-iosched: Rename "service_tree" to "st"
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-4-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 16:52:13 -0400
In-Reply-To: <1349119976-26837-4-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:44 -0400")
Message-ID: <x49ipatj4oy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> At quite a few places we use the keyword "service_tree" and I feel that
> names in CFQ are already very long and they need to be shortened a bit
> where appropriate.
>
> So this patch just renames "service_tree" to "st" at most of the places.
> No functionality change.

NACK.

> -	struct cfq_rb_root service_trees[2][3];
> -	struct cfq_rb_root service_tree_idle;
> +	struct cfq_rb_root sts[2][3];
> +	struct cfq_rb_root st_idle;

Honestly, who looks at sts and thinks "service trees?"
