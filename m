Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1JMGcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:32:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53275 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1JMGcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <4E94B9FD.5030500@tilera.com>
References: <4E94B9FD.5030500@tilera.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Oct 2011 18:31:40 +1200
X-Google-Sender-Auth: j9iAtiB9UU4O1ikrIIp3_BtgCCE
Message-ID: <CA+55aFwLWrurcrjX86wBR_eDurvGnsYGOqORXZZ9vyzdM2Ff2Q@mail.gmail.com>
Subject: Re: [GIT PULL] arch/tile update for 3.1
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 9:49 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>
> Please pull the following trivial change for 3.1 from:
>
>  git://github.com/cmetcalf-tilera/linux-tile.git stable
>
> This change allows 3.1-rc9 to build for the Tile architecture.  A bombing
> of <asm/atomic.h> to <linux/atomic.h> erroneously modified a couple
> of places where we were relying on some assembly constants in the tile
> <asm/atomic.h>.  Thanks!

This is not *at*all* what I get when I pull that branch.

I get a merge and two other commits too.

Not pulled.

         Linus
