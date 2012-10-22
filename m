Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2JVFme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 01:42:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45994 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab2JVFmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 01:42:33 -0400
Date: Mon, 22 Oct 2012 06:42:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/2] char_dev: pin parent kobject
Message-ID: <20121022054228.GX2616@ZenIV.linux.org.uk>
References: <20121021073928.GV2616@ZenIV.linux.org.uk>
 <1350867440-6109-1-git-send-email-dmitry.torokhov@gmail.com>
 <CA+55aFyg_TtKn5ikYBm2i3uSRwjskY1Rowj3mNZ285hh8hKWDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyg_TtKn5ikYBm2i3uSRwjskY1Rowj3mNZ285hh8hKWDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 08:02:12AM +0300, Linus Torvalds wrote:
> This series looks good to me, and looks to fix the issue about as
> cleanly as it can. Al, holler if you have any concerns, but I'm
> planning on applying it ASAP,

Add my ACKed-by.  And from the look of it, we'll need something similar
at least in drivers/mtd/ubi in addition to evdev patch.
