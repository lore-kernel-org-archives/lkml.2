Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1BONzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:55:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1BONzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:55:17 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] aio: Fix use after free bugs
References: <1297774764-32731-1-git-send-email-jack@suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 15 Feb 2011 08:55:13 -0500
In-Reply-To: <1297774764-32731-1-git-send-email-jack@suse.cz> (Jan Kara's
	message of "Tue, 15 Feb 2011 13:59:22 +0100")
Message-ID: <x49aahxe726.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hi Al,
>
>   The following two patches fix use after free bugs in AIO code.  I'm not
> completely sure you're the right one to merge these but hopefully yes ;).
> Could you please merge them? Thanks.

I've always pushed aio changes through akpm, fwiw.

Cheers,
Jeff
