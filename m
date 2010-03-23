Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0CWUpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:45:39 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:34505 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab0CWUph (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:45:37 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-fsdevel@vger.kernel.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: RFC: direct MTD support for SquashFS
References: <87vdcwv139.fsf@tac.ki.iif.hu>
	<87ljdsibqe.fsf@macbook.be.48ers.dk> <87r5nhziss.fsf@tac.ki.iif.hu>
	<bffbecbb1003181440kc78f4dbvd25d4e2ea17b52e5@mail.gmail.com>
Date: Tue, 23 Mar 2010 21:45:19 +0100
In-Reply-To: Ferenc Wagner's message of "Tue\, 23 Mar 2010 12\:35\:02 +0100"
Message-ID: <874ok6py1s.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner <wferi@niif.hu> writes:

> I've got one more patch, which I forgot to export, to pull out the
> common logic from the backend init functions back into squashfs_read_data().
> With the bdev backend, that entails reading the first block twice in a
> row most of the time.  This again could be worked around by extending
> the backend interface, but I'm not sure if it's worth it.

Here it is.  I also corrected the name of SQUASHFS_METADATA_SIZE, so it
may as well compile now.
-- 
Regards,
Feri.
