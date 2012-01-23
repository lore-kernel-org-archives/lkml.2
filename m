Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2AWQ1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:27:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2AWQ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:27:04 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Bryn M. Reeves" <bmr@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] fs: Invalidate the cache for a parent block-device if fsync() is called for a partition
References: <4F19356E.3020708@redhat.com>
	<1327315109-7740-1-git-send-email-ndevos@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Jan 2012 11:27:02 -0500
In-Reply-To: <1327315109-7740-1-git-send-email-ndevos@redhat.com> (Niels de
	Vos's message of "Mon, 23 Jan 2012 10:38:29 +0000")
Message-ID: <x49ehuqbd0p.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niels de Vos <ndevos@redhat.com> writes:

> Executing an fsync() on a file-descriptor of a partition flushes the
> caches for that partition by calling blkdev_issue_flush(). However, it
> seems that reading data through the parent device will still return the
> old cached data.

What problem, exactly, are you trying to fix?  Could you please post a
reproducer?

Cheers,
Jeff
