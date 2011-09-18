Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab1IRXTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 19:19:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34240 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab1IRXTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 19:19:40 -0400
Subject: Re: [PATCH] x86_64: permit to configure ISA support also for x86_64
 systems
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Valdis.Kletnieks@vt.edu
Cc: Wolfgang Grandegger <wg@grandegger.com>, x86@kernel.org,
        SocketCAN Core Mailing List <socketcan-core@lists.berlios.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Willy Lambert <lambert.willy@gmail.com>
Date: Sun, 18 Sep 2011 19:19:29 -0400
In-Reply-To: <63081.1316200771@turing-police.cc.vt.edu>
References: <4E731565.5050307@grandegger.com>
	 <63081.1316200771@turing-police.cc.vt.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 
Content-Transfer-Encoding: 7bit
Message-ID: <1316387978.19323.4.camel@nayuki.kepstin.ca>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 15:19 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 16 Sep 2011 11:22:45 +0200, Wolfgang Grandegger said:
> > There are 64-bit systems out there, like the ATOM N450, which
> > have ISA slots.
> 
> That's a scary thought...
> 
> > +if X86_32
> > +
> >  config EISA
> 
> But not as scary as the implication that the N450 has ISA but *not* EISA??!?

Don't get confused, EISA is a completely different bus from ISA! Take a
look at
http://en.wikipedia.org/wiki/Extended_Industry_Standard_Architecture
The ports are physically different from standard ISA (although they are
backwards compatible), and it requires some complicated BIOS
configuration for cards to be detected... I've only ever seen it once on
an old 486 portable computer. (The BIOS battery had gone, so it lost its
EISA configuration info, and wouldn't boot because it failed to detect
the IDE controller.)

The Atom N450 board that Wolfgang has almost certainly does not support
EISA.

Calvin

-- 
Calvin Walton <calvin.walton@kepstin.ca>

