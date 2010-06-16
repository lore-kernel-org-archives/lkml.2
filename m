Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543Ab0FPUYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:24:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46065 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab0FPUYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:24:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: [Bug 16222] Re: 2.6.35-rc{12} regression: inactive console corrupted
Date: Wed, 16 Jun 2010 22:23:06 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20100612103321.GA1458@ucw.cz> <201006152238.12022.maciej.rutecki@gmail.com> <20100616065055.GA4112@elf.ucw.cz>
In-Reply-To: <20100616065055.GA4112@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006162223.06919.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 16, 2010, Pavel Machek wrote:
> Hi!
> 
> > > When something happens on inactive  console (using fbcon), display is
> > > corrupted -- lines at end of screen are not erased properly.
> > > 
> > > I see it on zaurus, but I suspect problem is generic.
> > 
> > I created a Bugzilla entry at 
> > https://bugzilla.kernel.org/show_bug.cgi?id=16222
> > for your bug report, please add your address to the CC list in there, thanks!
> 
> It seems that problem is fixed in -rc3... this one can be closed.


