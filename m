Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab2EYOIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 10:08:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:34156 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2EYOIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 10:08:51 -0400
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in
 tty_lock_pair(v1)
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20120525150141.7a099aa3@pyramind.ukuu.org.uk>
References: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
	 <CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
	 <1337952533.9783.195.camel@laptop>
	 <20120525144713.6946df1e@bob.linux.org.uk>
	 <1337953922.9783.205.camel@laptop>
	 <20120525150141.7a099aa3@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 16:08:40 +0200
Message-ID: <1337954920.9783.207.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 15:01 +0100, Alan Cox wrote:
> 
> It applies on top of the other patches being tested in the thread on the
> lockdep warning.

You're really going to make me hunt and peck patches from lkml?

/me looses interest and gets on with reducing his inbox.

