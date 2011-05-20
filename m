Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935198Ab1ETDy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:54:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933275Ab1ETDy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:54:56 -0400
Subject: Re: linux-next: manual merge of the tip tree with the kbuild tree
From: Steven Rostedt <srostedt@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <20110520133631.d663013a.sfr@canb.auug.org.au>
References: <20110520133631.d663013a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Thu, 19 May 2011 23:54:26 -0400
Message-ID: <1305863666.2886.0.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 13:36 +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in Makefile
> between commit 28bc20dccadc ("kbuild: implement several W= levels") from
> the kbuild tree and commit 85356f802225 ("kbuild/recordmcount: Add
> RECORDMCOUNT_WARN to warn about mcount callers") from the tip tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


