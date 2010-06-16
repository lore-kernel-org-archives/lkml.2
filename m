Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab0FPK46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab0FPK44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:56:56 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Priit Laes <plaes@plaes.org>
Cc: linux-netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: IMAP through SSH tunnels stopped working in 2.6.35
References: <1276683847.3874.25.camel@chi>
X-Yow: Am I accompanied by a PARENT or GUARDIAN?
Date: Wed, 16 Jun 2010 12:56:53 +0200
In-Reply-To: <1276683847.3874.25.camel@chi> (Priit Laes's message of "Wed, 16
	Jun 2010 13:24:07 +0300")
Message-ID: <m3ocfbjle2.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Priit Laes <plaes@plaes.org> writes:

> I recently tried out 2.6.35-rc3 kernel (latest Linus's tree), where I
> noticed that I couldn't access my IMAP accounts through ssh tunnel
> anymore because connection timeouts. Things used to work in 2.6.34-rc7+.

See <https://bugzilla.kernel.org/show_bug.cgi?id=16188>.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
