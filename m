Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab0EaH42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 03:56:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:34131 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab0EaH40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 03:56:26 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Leandro Lucarella <llucax@gmail.com>
Subject: Re: intel graphic card hanging (Hangcheck timer elapsed... GPU hung)
Date: Mon, 31 May 2010 09:56:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
References: <20100531004450.GU17817@burns.springfield.home>
In-Reply-To: <20100531004450.GU17817@burns.springfield.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005310956.41099.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. Mai 2010 02:44:50 schrieb Leandro Lucarella:
> Hi. I just wanted to say that I was hitting this bug too. It seems to be
> a problem associated with xscreensaver and/or OpenGL. Looking for
> information on the web I found some bug report that said something about
> OpenGL (I can't find it now) so I tried deactivating xscreensaver and
> the system is working very stable, no GPU hungs in 10 days of uptime.
> When I had xscreensaver active the X server crashed in a couple of days
> and sometime I got the GPU hung error in dmesg but X didn't crashed.

Please try the 3DKnots screensaver.

	Regards
		Oliver
