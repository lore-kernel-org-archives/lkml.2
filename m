Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab2KXSC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 13:02:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864Ab2KXSC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 13:02:28 -0500
Date: Sat, 24 Nov 2012 19:02:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] uprobes: locking changes for filtering
Message-ID: <20121124180213.GA30963@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of
"[PATCH 0/7] uprobes: register/unregister preparations for filtering"

4/4 is not really needed and I won't insist if you dislike it.
Just this ->copy_mutex annoys me ;)

Please review. filter_chain() is almost ready, just we need to
discuss (again) its arguments/etc and reintroduce uc->filter().

Oleg.

