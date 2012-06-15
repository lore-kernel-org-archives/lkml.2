Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2FOK5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 06:57:07 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59293 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab2FOK5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 06:57:04 -0400
Date: Fri, 15 Jun 2012 12:00:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Message-ID: <20120615120032.235648f1@pyramind.ukuu.org.uk>
In-Reply-To: <1339757457-15646-1-git-send-email-jack@suse.cz>
References: <1339757457-15646-1-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 12:50:57 +0200
Jan Kara <jack@suse.cz> wrote:

> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: James Bottomley <JBottomley@parallels.com>
> CC: linux-scsi@vger.kernel.org
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Alan Cox <alan@linux.intel.com>

