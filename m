Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0ERB0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 21:26:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab0ERB0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 21:26:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Tridgell <tridge@samba.org>, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Jakub Jelinek <jakub@redhat.com>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if
	same_thread_group()
In-Reply-To: Oleg Nesterov's message of  Monday, 17 May 2010 21:54:14 +0200 <20100517195414.GA21504@redhat.com>
References: <20100517195414.GA21504@redhat.com>
X-Windows: you'd better sit down.
Message-Id: <20100518012547.0BE09402C2@magilla.sf.frob.com>
Date: Mon, 17 May 2010 18:25:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

I concur that there is no real security benefit from checking uids for any
CLONE_VM case.  But there is also no reason to change the old behavior in
this corner for any case but CLONE_THREAD.


Thanks,
Roland
