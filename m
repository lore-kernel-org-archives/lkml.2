Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2IEApV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:45:21 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:58841 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2IEApU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120904221641.GL3334@redhat.com>
References: <1346750457-12385-1-git-send-email-walken@google.com>
	<1346750457-12385-3-git-send-email-walken@google.com>
	<20120904142745.GE3334@redhat.com>
	<20120904215347.GA6769@google.com>
	<20120904221641.GL3334@redhat.com>
Date: Tue, 4 Sep 2012 17:45:19 -0700
Message-ID: <CANN689Gg9MAzoJ6Yfa0USgD74+Ga+jrecS+a7DaZuMMfKizZPQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm: fix potential anon_vma locking issue in mprotect()
From: Michel Lespinasse <walken@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, riel@redhat.com, peterz@infradead.org,
        hughd@google.com, daniel.santos@pobox.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 3:16 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> I would suggest to do the strict fix as above in as patch 1/8 and push
> it in -mm, and to do only the optimization removal in 3/8. I think
> we want it in -stable too later, so it'll make life easier to
> cherry-pick the commit if it's merged independently.

All right. So I did this and the strict fix got into Andrew's tree as
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch

Andrew: when you try applying this series, this patch (2/7) won't
apply due to the strict fix being already there. Please just skip it
(and replace patch 4/7 with the replacement I'm about to send, so that
we end up with the same end state)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
