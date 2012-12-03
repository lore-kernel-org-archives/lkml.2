Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2LCCor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:44:47 -0500
Received: from ozlabs.org ([203.10.76.45]:55843 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2LCCoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:44:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 0/2] modsign: fix missing symbol prefix
In-Reply-To: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
References: <1353672496-10789-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Dec 2012 13:08:11 +1030
Message-ID: <87lidfj1ws.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
> These patches fix linker errors on blackfin and metag when module
> signing is enabled. This is due to the use of symbol prefixes on these
> architectures, and the asm in modsign_pubkey.c not prefixing one.

Sorry, I was away last week.

I've applied these to my fixes branch, and will push to Linus now.

Thanks,
Rusty.
