Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab1IPRu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:50:29 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38965 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1IPRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:50:28 -0400
Date: Fri, 16 Sep 2011 19:50:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alvaro Herrera <alvherre@commandprompt.com>
Cc: Andres Freund <andres@anarazel.de>, Matthew Wilcox <matthew@wil.cx>,
        Andi Kleen <andi@firstfloor.org>, viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        robertmhaas <robertmhaas@gmail.com>,
        Pg Hackers <pgsql-hackers@postgresql.org>
Subject: Re: [HACKERS] Improve lseek scalability v3
Message-ID: <20110916175027.GF7761@one.firstfloor.org>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161616.50004.andres@anarazel.de> <20110916153620.GA9913@parisc-linux.org> <201109161927.34472.andres@anarazel.de> <1316194619-sup-2946@alvh.no-ip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316194619-sup-2946@alvh.no-ip.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> One other thing we're interested in is portability.  I mean, even if
> Linux were to introduce a new hypothetical syscall that was able to
> return the file size at a ridiculously low cost, we probably wouldn't
> use it because it'd be Linux-specific.  So an improvement of lseek()
> seems to be the best option.

Fully agreed. It doesn't make any sense at all to implement special
syscalls just to workaround a basic system call not scaling.

-Andi
