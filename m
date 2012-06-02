Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671Ab2FBOmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 10:42:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36384 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab2FBOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 10:42:49 -0400
Date: Sat, 2 Jun 2012 15:42:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] frv: Remove bogus closing parenthesis
Message-ID: <20120602144245.GM30000@ZenIV.linux.org.uk>
References: <1338635319-28226-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338635319-28226-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 01:08:39PM +0200, Geert Uytterhoeven wrote:
> Introduced by commit 6fd84c0831ec78d98736b76dc5e9b849f1dbfc9e
> ("TIF_RESTORE_SIGMASK can be set only when TIF_SIGPENDING is set")

Applied and pushed into signal.git#for-linus.  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Geert Uytterhoeven (1):
      frv: Remove bogus closing parenthesis

Diffstat:
 arch/frv/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

