Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1FXPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 11:36:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab1FXPf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 11:35:59 -0400
Date: Fri, 24 Jun 2011 17:33:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ptrace_reparented fixes/cleanups
Message-ID: <20110624153330.GA9346@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Another thing I wanted to cleanup for so long time.

ptrace_reparented() is wrong. Now we have real_parent_is_ptracer()
which does the right thing, but the name is ugky and it is not
exported.

Fix ptrace_reparented() and kill the recently added
real_parent_is_ptracer().

Oleg.

