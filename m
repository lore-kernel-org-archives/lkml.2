Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1AZLYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:24:09 -0500
Received: from www.tglx.de ([62.245.132.106]:34644 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1AZLYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:24:07 -0500
Date: Wed, 26 Jan 2011 12:22:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Alessio Igor Bogani <abogani@texware.it>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jan Blunck <jblunck@infradead.org>,
        John Kacur <jkacur@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.org>,
        Paul Menage <menage@google.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 20/20] BKL: That's all, folks
In-Reply-To: <1295993854-4971-21-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1101261221380.31804@localhost6.localdomain6>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de> <1295993854-4971-21-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011, Arnd Bergmann wrote:

> This removes the implementation of the big kernel lock,
> at last. A lot of people have worked on this in the
> past, I so the credit for this patch should be with
> everyone who participated in the hunt.
> 
> The names on the Cc list are the people that were the
> most active in this, according to the recorded git
> history, in alphabetical order.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Alessio Igor Bogani <abogani@texware.it>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Hendry <andrew.hendry@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jan Blunck <jblunck@infradead.org>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Oliver Neukum <oliver@neukum.org>
> Cc: Paul Menage <menage@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Trond Myklebust <Trond.Myklebust@netapp.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

Thanks a lot to everyone involved !
