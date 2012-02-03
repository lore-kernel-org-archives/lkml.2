Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab2BCSkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:40:11 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37044 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab2BCSkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:40:09 -0500
Date: Fri, 3 Feb 2012 13:40:09 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] genirq: better error messages for disabled IRQs
Message-ID: <20120203184009.GA18471@Brahman>
References: <1328238951-15059-1-git-send-email-edward.donovan@numble.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328238951-15059-1-git-send-email-edward.donovan@numble.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, may I ask you to review this?  I haven't had luck reaching
Thomas, and I don't know who else to bug.  I forgot to put 'resubmit'
in the subject, but this is the third try.  As code, it truly is
trivial; it's just a message to the user.  I've seen it so often,
working on it myself, and for other users, that it sticks out like a
sore thumb to me, now.

It may still be in your mailbox, but I'll follow up with the patch
again.

Thank you,

Ed
