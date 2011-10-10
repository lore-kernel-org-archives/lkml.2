Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1JJS76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:59:58 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:50042 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1JJS76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:59:58 -0400
Subject: Re: [PATCH] ide: Fix file references in drivers/ide/
From: Paul Bolle <pebolle@tiscali.nl>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Johann Felix Soden <johfel@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, trivial@kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        David Miller <davem@davemloft.net>
In-Reply-To: <4E933B4C.5050104@xenotime.net>
References: <1317683499.5990.2.camel@LAPJFS> <4E933B4C.5050104@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 20:59:46 +0200
Message-ID: <1318273186.18122.16.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 11:37 -0700, Randy Dunlap wrote:
> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> Fix file references in drivers/ide/
> 
> There are a lot of file references to now moved or deleted files in the
> whole tree, especially in documentation and Kconfig files.

Yes, there's lots of fun to be had by cleaning up those references.

Do note that I already cleaned up broken references (from anywhere in
the tree) to files in Documentation/ some time ago. See commit
395cf9691d72173d8cdaa613c5f0255f993af94b ("doc: fix broken references"),
which is now in trivial/for-next. So that's another part of this job
that's already been done. 


Paul Bolle

