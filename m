Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0DUJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:25:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57959 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753510Ab0DUJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:25:27 -0400
Date: Wed, 21 Apr 2010 10:27:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
In-Reply-To: <20100421012908.GB24251@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
	<20100421012908.GB24251@us.ibm.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a change which must be discussed.  The use of this
> privilege can be completely prevented by having init remove
> CAP_GRANT_ID from its capability bounding set before forking any
> processes.

Which is a minor back compat issue - but you could start without it and
allow init to add it.

It seems a very complex interface to do a simple thing. A long time ago
there was discussion around extending the AF_UNIX fd passing to permit
'pass handle and auth' so you could send someone a handle with a "become
me" token attached.

Alan
