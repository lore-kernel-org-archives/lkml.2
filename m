Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1JYNNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:13:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1JYNNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:13:20 -0400
Date: Tue, 25 Oct 2011 15:13:15 +0200
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mikulas Patocka <mpatocka@redhat.com>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20111025131315.GA1899@suse.de>
References: <20111025.063206.2273357152859701628.davem@davemloft.net>
 <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw1GVvszqoC_f0RAvG5t1xj0CSYLhLU=y0gQ+_54Gsomw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:46:11PM +0200, Linus Torvalds wrote:
> Anyway, after that rant about really bad practices, let me say that I
> did fix up the conflict and I think it's right. But I won't guarantee
> it, so please check the changes to fs/sysfs/dir.c.

I think it looks ok, I've booted the merge result, and am typing and
sending this from the new kernel, and it hasn't crashed yet :)

greg k-h
