Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0DTDci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:32:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab0DTDcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:32:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [REGRESSION 2.6.34] Suspend fails in pm_test=processor on Dell laptop
Date: Tue, 20 Apr 2010 05:33:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4bcb1cf2.116bdc0a.2008.6f5a@mx.google.com>
In-Reply-To: <4bcb1cf2.116bdc0a.2008.6f5a@mx.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201004200533.13219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 April 2010, Ben Gamari wrote:
> Hey all,
> 
> It seems that something in the 2.6.34 merge cycle has broken suspend to RAM on
> my Dell Latitude D830. While suspend has been rock solid for several release
> cycles, as of 2.6.34-rc4 it locks up on suspend. All of the pm_test options up
> to processor work fine, precluding a driver issue.

Hmm, does the "processors" work?

> Unfortunately, I've been unable to get any useful output from the serial
> console during suspend. I'll try bisecting and report back when I have more
> details. Let me know what else I can do to help.

I can't reproduce this, so it looks hardware or BIOS-related.  Or it's an
obscure x86 bug.

Rafael
