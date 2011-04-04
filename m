Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab1DDPzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:55:05 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49957 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754610Ab1DDPzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:55:04 -0400
Date: Mon, 4 Apr 2011 15:54:57 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        david@woodhou.se
Subject: Re: [PATCH 0/7] char/mei: Intel MEI Driver
Message-ID: <20110404155457.GD1878@localhost.ucw.cz>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> ďťżIntel MEI Driver
> =======================
> The Intel Management Engine (Intel ME) is an isolated and 
> protected computing resources (Coprocessor) residing inside 
> Intel chipsets. The Intel ME provides support for computer/IT 
> management features.

What is expected use of MEI?

>  drivers/char/Kconfig           |   12 +-
>  drivers/char/Makefile          |    1 +
>  drivers/char/mei/Makefile      |   19 +
>  drivers/char/mei/hw.h          |  511 +++++++++++++
>  drivers/char/mei/init.c        |  834 +++++++++++++++++++++
>  drivers/char/mei/interface.c   |  478 ++++++++++++
>  drivers/char/mei/interface.h   |  122 +++
>  drivers/char/mei/interrupt.c   | 1582 ++++++++++++++++++++++++++++++++++++++++
>  drivers/char/mei/iorw.c        |  608 +++++++++++++++
>  drivers/char/mei/main.c        | 1442 ++++++++++++++++++++++++++++++++++++
>  drivers/char/mei/mei.h         |  156 ++++
>  drivers/char/mei/mei_version.h |   31 +
>  include/linux/mei.h            |  109 +++

No docs describing the interface?

> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

So anyone reading this through web interface needs to "delete all 
copies"?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
