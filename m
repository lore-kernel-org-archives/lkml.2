Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab0FGEBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 00:01:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737Ab0FGEBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 00:01:34 -0400
Date: Sun, 6 Jun 2010 20:55:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@gmail.com>
cc: Jiri Slaby <jslaby@suse.cz>, "Justin P. Mattock" <justinmattock@gmail.com>,
       frankpzh@gmail.com, Greg KH <gregkh@suse.de>,
       =?ISO-8859-15?Q?Ortwin_Gl=FCck?= <odi@odi.ch>,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)
In-Reply-To: <AANLkTimnMudoLsQl2Nu9_5eVM3QoSiAJv1WrbbA4Dam0@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006062054520.3515@i5.linux-foundation.org>
References: <4C0C0DD8.5030106@gmail.com> <1275860015-6643-1-git-send-email-jslaby@suse.cz> <AANLkTimnMudoLsQl2Nu9_5eVM3QoSiAJv1WrbbA4Dam0@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Dave Airlie wrote:
> 
> This helps a lot of issues on KMS systems,. can you get it to Linus?

Found this thread while following another thread. There were at least 
three different threads about the same issue, all looking at bug in 
different areas (ext4 too).

I reverted the original commit, and pushed out.

		Linus
