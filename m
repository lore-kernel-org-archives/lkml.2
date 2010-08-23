Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0HWQ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0HWQ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:58:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
X-Fcc: ~/Mail/linus
Cc: Matthew Wilcox <matthew@wil.cx>,
        Richard Cochran <richardcochran@gmail.com>,
        john stultz <johnstul@us.ibm.com>, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] posix clocks: introduce syscall for clock tuning.
In-Reply-To: Arnd Bergmann's message of  Monday, 23 August 2010 16:46:00 +0200 <201008231646.00357.arnd@arndb.de>
References: <cover.1282550649.git.richard.cochran@omicron.at>
	<201008231457.26690.arnd@arndb.de>
	<20100823134330.GM12892@parisc-linux.org>
	<201008231646.00357.arnd@arndb.de>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20100823165758.4624E400BF@magilla.sf.frob.com>
Date: Mon, 23 Aug 2010 09:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EOPNOTSUPP is also called ENOTSUP in userland.  ENOTSUP is the appropriate
POSIX errno code for a situation such as a clock type that cannot be used
in a certain call (like setting when you can only read it, etc.).


Thanks,
Roland
