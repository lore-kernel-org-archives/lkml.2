Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2KTVAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:00:04 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36728 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2KTVAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:00:02 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 Nov 2012 12:59:40 -0800
X-Google-Sender-Auth: igc97tyvich5Z_DgWumiSIAsMW8
Message-ID: <CAB=NE6WTFv80w6bkQNqaAG69CADmdiqa-tLKD9s=h_p+1D92tQ@mail.gmail.com>
Subject: Streamlining Developer's Certificate of Origin, Signed-off-by tag
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it turns out everyone and their mother's attorneys love the
Signed-off-by tag and its definition as explained on the Linux kernel
under the Developer's Certificate of Origin. Its to the extent other
projects have picked it up and started documenting their own
documentation for submitting patches to embrace the same definition,
some without knowing what they were doing, some knowingly and
rightfully doing so. I think it'd be good to see more embracement of
the tag but to help do this it occurs to me perhaps it'd be good to
treat  the 'Developer's Certificate of Origin' as a standalone
document that we can reference independently, and then have the kernel
itself refer to it. That is, provide a unified easy way to refer to
the practice for requiring the SOB tag and what it means.

Thoughts?

  Luis
