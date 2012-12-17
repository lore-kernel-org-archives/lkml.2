Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2LQQGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:06:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab2LQQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:06:46 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, tj@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] core block IO bits for 3.8
References: <50CF3B82.9000904@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 17 Dec 2012 11:06:39 -0500
In-Reply-To: <50CF3B82.9000904@kernel.dk> (Jens Axboe's message of "Mon, 17
	Dec 2012 16:34:26 +0100")
Message-ID: <x49licwwtm8.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> - Export control of bdi flusher thread CPU mask and default to using the
>   home node (if known) from Jeff.

I certainly wouldn't mind this going in, but I think Tejun NACKed this
patch.  Tejun?

Cheers,
Jeff
