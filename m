Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab2CAUZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:25:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab2CAUZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:25:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>
Subject: Re: [RFC PATCH 01/22] iov_iter: move into its own file
References: <1330377576-3659-1-git-send-email-dave.kleikamp@oracle.com>
	<1330377576-3659-2-git-send-email-dave.kleikamp@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 01 Mar 2012 15:25:28 -0500
In-Reply-To: <1330377576-3659-2-git-send-email-dave.kleikamp@oracle.com> (Dave
	Kleikamp's message of "Mon, 27 Feb 2012 15:19:15 -0600")
Message-ID: <x49sjhsax1j.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> From: Zach Brown <zab@zabbo.net>
>
> This moves the iov_iter functions in to their own file.  We're going to
> be working on them in upcoming patches.  They become sufficiently large,
> and remain self-contained, to justify seperating them from the rest of
> the huge mm/filemap.c.
>
> Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
> Cc: Zach Brown <zab@zabbo.net>

Acked-by: Jeff Moyer <jmoyer@redhat.com>
