Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1JKIBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:01:40 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:36883 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1JKIBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:01:40 -0400
Subject: Re: [PATCH] Fix file references in Kconfig files
From: Paul Bolle <pebolle@tiscali.nl>
To: Johann Felix Soden <johfel@gmx.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1318288249.12675.6.camel@LAPJFS>
References: <1317683499.5990.2.camel@LAPJFS> <4E934066.80109@xenotime.net>
	 <alpine.LNX.2.00.1110102350170.14768@pobox.suse.cz>
	 <1318288249.12675.6.camel@LAPJFS>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 10:01:19 +0200
Message-ID: <1318320079.18122.38.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 01:10 +0200, Johann Felix Soden wrote:
> This patch fixes file references to moved or deleted files
> outside of Documentation/.

Apparently you grepped on something like "<file:.*". This triggers an
issue I've been wondering about a bit.

Would anyone know why some file references are wrapped in a "<file:" -
">" pair while others are not? The same thing can be seen with "http://"
links: some are wrapped in angle brackets while others are not. What do
these brackets (and the "file:" prefix) actually provide?


Paul Bolle

