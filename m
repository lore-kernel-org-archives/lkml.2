Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab3AESNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 13:13:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab3AESNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 13:13:08 -0500
Date: Sat, 5 Jan 2013 19:12:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: CAI Qian <caiqian@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linda Wang <lwang@redhat.com>, Matt Zywusko <mzywusko@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Was: ssetmask/sgetmask syscalls
Message-ID: <20130105181254.GA13076@redhat.com>
References: <688203485.8555438.1357377797739.JavaMail.root@redhat.com> <1757046472.8555813.1357378462241.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1757046472.8555813.1357378462241.JavaMail.root@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05, CAI Qian wrote:
>
> FYI, I noticed that ssetmask/sgetmask syscalls starting to
> fail
>
> ssetmask01    1  TFAIL  :  sgetmask() failed: TEST_ERRNO=???(0): Success

Thanks!

Should be fixed by 1/2. Probably trivial enough for 3.8

2/2 is a minor "while at it" cleanup.

Oleg.

