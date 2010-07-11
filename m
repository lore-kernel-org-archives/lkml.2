Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab0GKVk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 17:40:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38236 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0GKVk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 17:40:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: stable? quality assurance?
Date: Sun, 11 Jul 2010 23:38:28 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de> <201007111651.42963.Martin@lichtvoll.de> <20100711172252.GA3379@1wt.eu>
In-Reply-To: <20100711172252.GA3379@1wt.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007112338.28693.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 11, 2010, Willy Tarreau wrote:
> Hi Martin,
> 
> On Sun, Jul 11, 2010 at 04:51:42PM +0200, Martin Steigerwald wrote:
> > I hope that someone answers who actually can take some critique. From the 
> > current replies I perceive a lack of that ability.
> 
> well, I'll try to do then :-)
> 
> There were some threads in the past about kernel releases quality,
> where Linus explained why it could not be completely black or white.
> 
> Among the things he explained, I remember that one of primary concern
> was the inability to slow down development. I mean, if he waits 2 more
> weeks for things to stabilize, then there will be two more weeks of
> crap^H^H^H^Hdevelopment merged in next merge window, so in fact this
> will just shift dates and not quality.
...
> It's not really advisable to call dot-0 releases "unstable" because
> it will only result in shifting the adoption point between the user
> classes above.

IMnshO it's not exactly fair to call them "stable" either.  I tend to call them
"major releases" which basically reflects what they are - events in the
development process that each start a new merge window.  Nothing more, either
way.

Rafael
