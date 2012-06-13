Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2FMHNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:13:01 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49641 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751222Ab2FMHNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:13:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18haDRmbHohbLcLL/sdMqB6sR+9I5fbyfO06w2gAb
	dWM41XnQ62ig6s
Message-ID: <1339571575.7472.78.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <efault@gmx.de>
To: Hugh Dickins <hughd@google.com>
Cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Date: Wed, 13 Jun 2012 09:12:55 +0200
In-Reply-To: <1339566974.7472.45.camel@marge.simpson.net>
References: <1339409176.7350.26.camel@marge.simpson.net>
	 <20120611133953.GI2425@linux.vnet.ibm.com>
	 <1339424543.7350.101.camel@marge.simpson.net>
	 <1339435214.7358.43.camel@marge.simpson.net>
	 <20120611180112.GD2521@linux.vnet.ibm.com>
	 <1339438242.7358.62.camel@marge.simpson.net>
	 <1339558508.7472.26.camel@marge.simpson.net>
	 <alpine.LSU.2.00.1206122120460.5221@eggly.anvils>
	 <1339566974.7472.45.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 07:56 +0200, Mike Galbraith wrote:

> Question remains though.  Maybe the box hit some other problem that led
> to death by RCU gripage, but the info I received indicated the box was
> in the midst of a major spin-fest.

To (maybe) speak more clearly, since it's a mutex like any other mutex
that loads of CPUs can hit if you've got loads of CPUs, did huge box
driver do something that we don't expect so many CPUs to be doing, thus
instigate simultaneous exit trouble (ie shoot self in foot), or did that
mutex addition create the exit trouble which box appeared to be having?

Too bad box RCU griped itself to death, would have been nice to have
more than a snippet.

-Mike

