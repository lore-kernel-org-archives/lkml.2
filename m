Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1CEL0u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 06:26:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54087 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1CEL0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 06:26:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.38-rc6+: oops while hibernating, pcmcia?
Date: Sat, 5 Mar 2011 12:26:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7+; KDE/4.4.4; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20110305054426.GA2096@elf.ucw.cz>
In-Reply-To: <20110305054426.GA2096@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051226.58032.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 05, 2011, Pavel Machek wrote:
> Hi!
> 
> Unfortunately it did not made it do disk. Thinkpad x60. PCMCIA was in
> the backtrace, and yes, I had CF card in the PCMCIA slot. Certainly
> not 100% repeatable, as it was 3rc hibernate or so...

I'd say it's a PCMCIA bug.  Is it reproducible without PCMCIA being in use?

Rafael
