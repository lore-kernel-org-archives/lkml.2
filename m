Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2JAU6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:58:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab2JAU57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:57:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 05/15] cfq-iosched: Get rid of unnecessary local variable
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-6-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 16:57:54 -0400
In-Reply-To: <1349119976-26837-6-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:46 -0400")
Message-ID: <x49a9w5j4fh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Use of local varibale "n" seems to be unnecessary. Remove it. This brings
> it inline with function __cfq_group_st_add(), which is also doing the
> similar operation of adding a group to a rb tree.
>
> No functionality change here.

Agreed.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
