Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2BBP7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:59:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab2BBP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:59:49 -0500
From: Aldy Hernandez <aldyh@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Torvald Riegel <triegel@redhat.com>,
        Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-ia64@vger.kernel.org, dsterba@suse.cz, ptesarik@suse.cz,
        rguenther@suse.de, gcc@gcc.gnu.org
Subject: Re: Memory corruption due to word sharing
References: <20120201151918.GC16714@quack.suse.cz>
	<CA+55aFy55Q=+pFCZcS9cOM6SL+ZT3sNDB+c4qFvVqwwSpTqJ7g@mail.gmail.com>
	<1328118174.15992.6206.camel@triegel.csb>
	<20120201194025.GG6148@sunsite.ms.mff.cuni.cz>
	<CA+55aFzVWjqcs1zRF-93_9yHRDS-YgmpgFTzACw6HQ-059U06Q@mail.gmail.com>
	<20120201201631.GW18768@tyan-ft48-01.lab.bos.redhat.com>
	<CA+55aFwcLpD2Cw5VxZ3ym66QBDAeDam3-hprivrC+keUMXJOtw@mail.gmail.com>
Reply-to: aldyh@redhat.com
Date: Thu, 02 Feb 2012 09:58:33 -0600
In-Reply-To: <CA+55aFwcLpD2Cw5VxZ3ym66QBDAeDam3-hprivrC+keUMXJOtw@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 1 Feb 2012 12:44:05 -0800")
Message-ID: <874nv9qlau.fsf@houston.quesejoda.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Seriously - is there any real argument *against* just using the base
> type as a hint for access size?

If I'm on the hook for attempting to fix this again, I'd also like to
know if there are any arguments against using the base type.
