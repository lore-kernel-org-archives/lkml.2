Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab2JAUvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:51:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132Ab2JAUun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:50:43 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 02/15] cfq-iosched: More renaming to better represent wl_class and wl_type
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
	<1349119976-26837-3-git-send-email-vgoyal@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Oct 2012 16:50:37 -0400
In-Reply-To: <1349119976-26837-3-git-send-email-vgoyal@redhat.com> (Vivek
	Goyal's message of "Mon, 1 Oct 2012 15:32:43 -0400")
Message-ID: <x49r4phj4rm.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Also at places I have got rid of keyword "serving" as it is obivious.

I don't agree with getting rid of serving.  After your patch, it looks
as though a cfqd has a static workload class and type.  It reads better
to me the way it is.

Cheers,
Jeff
