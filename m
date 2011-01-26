Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab1AZJNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:13:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:19724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925Ab1AZJNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:13:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,379,1291622400"; 
   d="scan'208";a="596575768"
Date: Wed, 26 Jan 2011 08:47:01 +0000
From: Alan Cox <alan@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
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
        Paul Menage <menage@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [PATCH 20/20] BKL: That's all, folks
Message-ID: <20110126084701.589322a2@bob.linux.org.uk>
In-Reply-To: <20110126061954.GA32096@elte.hu>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-21-git-send-email-arnd@arndb.de>
	<20110126061954.GA32096@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yay!
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Alan Cox <alan@linux.intel.com>

Nice to see it gone - it seemed such a good idea in Linux 1.3

Alan
