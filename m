Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0IPS1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:27:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35133 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0IPS1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:27:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Simon Kirby <sim@hostway.ca>
Subject: Re: [linux-pm] [2.6.36-rc4/HEAD] unable to handle kernel NULL pointer dereference?(plist_add)
Date: Thu, 16 Sep 2010 20:26:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@suse.de>,
        mark gross <markgross@thegnar.org>, Takashi Iwai <tiwai@suse.de>
References: <20100913070034.GA4820@hostway.ca> <201009142238.25840.rjw@sisk.pl> <20100915234633.GW23979@hostway.ca>
In-Reply-To: <20100915234633.GW23979@hostway.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009162026.17003.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 16, 2010, Simon Kirby wrote:
> On Tue, Sep 14, 2010 at 10:38:25PM +0200, Rafael J. Wysocki wrote:
> 
> > Hmm, interesting.  This looks like a plist corruption to me, but can you please
> > check (using gdb) what line of code corresponds to the address
> > plist_add+0x36/0xa0 ?
> 
> I ended up rebuilding since then, and I enabled a bunch of debugging
> stuff.  Does this help make it more obvious?  I'll try your other patch
> tonight, but I still don't get what's wrong with the existing code.

That's not necessary, since the https://bugzilla.kernel.org/show_bug.cgi?id=17922
patch works for you.

Thanks,
Rafael
