Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1KCVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:25:29 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:60075 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1KCVZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:25:27 -0400
Subject: Re: [GIT PULL] UML changes for 3.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
In-Reply-To: <4EB3045A.6050501@nod.at>
References: <4EB14F51.1050004@nod.at>
	 <1320348750.14409.249.camel@x61.thuisdomein>
	 <1320352899.14409.260.camel@x61.thuisdomein>
	 <1320354072.14409.265.camel@x61.thuisdomein>  <4EB3045A.6050501@nod.at>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Nov 2011 22:25:03 +0100
Message-ID: <1320355503.14409.269.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 22:15 +0100, Richard Weinberger wrote:
> I'm confused. What is "make update-po-config" supposed to do?
> It seems to iterate over all archs and reads their Kconfig, right?

It generates an enormous file (linux.pot) with all (help?) strings in
all Kconfig files that people could translate from English to other
languages. Seems like quite an effort to do that. I wonder if it has
ever been done.


Paul Bolle

