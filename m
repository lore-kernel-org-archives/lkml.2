Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab2BFUMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:12:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39651 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab2BFUMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:12:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [linux-pm] [PATCH] CPU C-state breakage with PM Qos change
Date: Mon, 6 Feb 2012 21:16:16 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: markgross@thegnar.org, Kevin Hilman <khilman@ti.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Pihet-XID, Jean" <j-pihet@ti.com>
References: <1328227065-22045-1-git-send-email-venki@google.com> <CAORVsuVCYp+Fmfaje-UDnv1=x0PqApML6Jb-Z6EG0425SuREMg@mail.gmail.com> <CAORVsuW7mBCZdGqScX5jjaYDhijZH_H7vDKkJ4v6WWHn9rUsGw@mail.gmail.com>
In-Reply-To: <CAORVsuW7mBCZdGqScX5jjaYDhijZH_H7vDKkJ4v6WWHn9rUsGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202062116.16744.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 06, 2012, Jean Pihet wrote:
> Rafael,
> 
> On Mon, Feb 6, 2012 at 11:18 AM, Jean Pihet <jean.pihet@newoldbits.com> wrote:
> > Hi Rafael, Mark,
> >
> > On Sun, Feb 5, 2012 at 12:04 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
> 
> >> In kernel/power/Makefile:
> >>
> >> obj-$(CONFIG_PM)                += main.o qos.o
> >>
> >> I guess that explains things. :-)
> > Initially I thought we should have a way of disabling the feature on
> > some (minimal) kernels and so thought CONFIG_PM was the option to use.
> >
> >> It's quite easy to make qos.o be independent of CONFIG_PM, in which case the
> >> code added by Venki can be removed, so patches welcome (for 3.4, though).
> > I am working on it, more to come soon.
> 
> I have a couple of patches ready, to be applied on 3.3-rc1 (so without
> Venki's patch applied).
> The first one is on PM QoS, the second one on per-device PM QoS. Is
> the latter needed?

I'm not sure without looking. :-)

Thanks,
Rafael
