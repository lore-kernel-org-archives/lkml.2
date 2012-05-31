Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2EaOJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 10:09:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab2EaOJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 10:09:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH 2/2] ocfs2: clear unaligned io flag when dio fails
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
	<1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 31 May 2012 10:09:09 -0400
In-Reply-To: <1338437550-24499-2-git-send-email-junxiao.bi@oracle.com>
	(Junxiao Bi's message of "Thu, 31 May 2012 12:12:30 +0800")
Message-ID: <x49fwagcuii.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junxiao Bi <junxiao.bi@oracle.com> writes:

> The unaligned io flag is set in the kiocb when an unaligned
> dio is issued, it should be cleared even when the dio fails,
> or it may affect the following io which are using the same
> kiocb.

What code is re-using kiocbs, much less re-using them without
re-initializing them?

-Jeff
