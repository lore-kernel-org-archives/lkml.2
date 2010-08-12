Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab0HLNa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 09:30:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab0HLNa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 09:30:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: akpm@linux-foundation.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] SCSI: fix bio.bi_rw handling
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
	<1281616266-4709-2-git-send-email-jslaby@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 12 Aug 2010 09:30:04 -0400
In-Reply-To: <1281616266-4709-2-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Thu, 12 Aug 2010 14:31:05 +0200")
Message-ID: <x49iq3g3qn7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> Return of the bi_rw tests is no longer bool after commit 74450be1. So
> testing against constants doesn't make sense anymore. Fix this bug in
> osd_req_read by removing "== 1" in test.
>
> This is not a problem now, where REQ_WRITE is 1, but this can change
> in the future and we don't want to rely on that.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
> Cc: Christoph Hellwig <hch@lst.de>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
