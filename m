Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab1ISP1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 11:27:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38024 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab1ISP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 11:27:39 -0400
Date: Mon, 19 Sep 2011 16:27:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Ian Kent <raven@themaw.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and
 x86_64
Message-ID: <20110919152735.GK2203@ZenIV.linux.org.uk>
References: <1316167604.6545.84.camel@localhost.localdomain>
 <20110916101903.GI2203@ZenIV.linux.org.uk>
 <1316169496.8502.6.camel@perseus.themaw.net>
 <1316332908.5814.22.camel@localhost.localdomain>
 <1316404368.3206.21.camel@perseus.themaw.net>
 <20110919061059.GJ2203@ZenIV.linux.org.uk>
 <CACCE520-D261-4B97-B208-1C44574886BF@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACCE520-D261-4B97-B208-1C44574886BF@m3y3r.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:30:42AM +0200, Thomas Meyer wrote:

> @al: what other autofs4 users are out there besides systemd?

	Are you serious?  You *do* realize that autofs is quite usable on
the benighted systems not infested with that... Fabulous Piece Of Software,
don't you?  Depending on your distribution, say apt-cache search autofs /
yum search autofs / whatever your equivalent is and examine the results.
Plus anything that has demonstrated the lack of taste equal to yours
and reimplemented that stuff, of course.

Sigh...  At least DJB fanboys usually do not ask "what other SMTP
users are out there besides qmail"...
