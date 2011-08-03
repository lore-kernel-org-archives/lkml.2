Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab1HCLFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 07:05:10 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:55840 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1HCLFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 07:05:05 -0400
Date: Wed, 3 Aug 2011 13:05:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Use "make -s" to silence everything except warnings/error
Message-ID: <20110803110502.GA18323@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.

Saw in an old thread that you mentioned that warnings were missed because
your computer is too quick.

If you pass "-s" like this:

    make -s -j4 ...

then you will no longer see the one-line-per-file output.

But warnings are displayed and is thus much more visible.

Just a hint in case you did not know.

	Sam
