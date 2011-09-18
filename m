Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1IRIBx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 04:01:53 -0400
Received: from www17.your-server.de ([213.133.104.17]:43130 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1IRIBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 04:01:52 -0400
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and
 x86_64
From: Thomas Meyer <thomas@m3y3r.de>
To: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
Date: Sun, 18 Sep 2011 10:01:42 +0200
In-Reply-To: <1316169496.8502.6.camel@perseus.themaw.net>
References: <1316167604.6545.84.camel@localhost.localdomain>
	 <20110916101903.GI2203@ZenIV.linux.org.uk>
	 <1316169496.8502.6.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1316332908.5814.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 16.09.2011, 18:38 +0800 schrieb Ian Kent:
> On Fri, 2011-09-16 at 11:19 +0100, Al Viro wrote:
> > On Fri, Sep 16, 2011 at 12:06:38PM +0200, Thomas Meyer wrote:
> > > autofs_v5_packet is 300 bytes on x86 and 304 bytes on x86_64.
> > > This difference is wrong and leads to a hang in systemd when running
> > > a x86 userspace on an x86_64 kernel.
> > 
> > NAK.
> > 
> > You are talking about the userland ABI.  With existing users.  Changing
> > it might help systemd (what the hell is it doing with autofs, anyway?),
> > but breaking existing binaries (you know, ones that *do* have some business
> > dealing with autofs) is not acceptable.
> 
> That's right.
> 
> Certainly my mistake (made a long time ago) and when I realized it I
> decided I would need to handle it in user space for the same reasons Al
> has mentioned.
> 

btw. where are the padding bytes are added? how to tell gcc to display
this?

with kind regards
thomas


