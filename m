Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab2B0Vhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 16:37:45 -0500
Received: from gate.crashing.org ([63.228.1.57]:60902 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703Ab2B0Vho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 16:37:44 -0500
Message-ID: <1330378346.11728.5.camel@pasglop>
Subject: Re: [PATCH 1/2] powerpc: Move GE GPIO and PIC drivers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: linuxppc-dev@lists.ozlabs.org, Wim Van Sebroeck <wim@iguana.be>,
        Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 08:32:26 +1100
In-Reply-To: <4F4B8BB2.1060004@ge.com>
References: <1328614121-17803-1-git-send-email-martyn.welch@ge.com>
	 <1328614121-17803-2-git-send-email-martyn.welch@ge.com>
	 <1330299464.20389.58.camel@pasglop> <4F4B8BB2.1060004@ge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 13:57 +0000, Martyn Welch wrote:

> This patch (or one like it) has been around for a while now. Kumar wanted me
> to put them here rather than sysdev[1], but I'm easy either way.

Ah well, I disagree with Kumar here :-) One thing you can do is put all
your platforms files including the drivers in platforms/ge, that works
too. What I don't want is to have stray files at the top-level of
platforms.

> > Also, use git mv so that the file moves appear as such in the history,
> > this will make review easier by clearly separating the move from actual
> > changes to the files.
> > 
> 
> Hmm, thought I'd done that. Will try again.

Could be the way you exported the patch, I don't remember the git option
off the top of my head but there's a way to make it show the moves as
such.

Cheers,
Ben.


