Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab2JTJwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 05:52:30 -0400
Received: from asav4.lyse.net ([81.167.36.150]:34553 "EHLO asav4.lyse.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab2JTJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 05:52:29 -0400
X-Greylist: delayed 1879 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Oct 2012 05:52:29 EDT
Date: Sat, 20 Oct 2012 11:24:02 +0200
From: Helge Hafting <helge.hafting@ntebb.no>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>, alsa-devel <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] 3.6.0 regression, distorted sound failure while
 using jack and hd-audio
Message-ID: <20121020112402.0f1119e5@tenkende-august.homelinux.net>
In-Reply-To: <s5h626ljgc7.wl%tiwai@suse.de>
References: <20121007213452.08e29880@tenkende-august.homelinux.net>
	<5071F3CF.8070907@gmail.com>
	<s5h626ljgc7.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2012 14:31:04 +0200
Takashi Iwai <tiwai@suse.de> wrote:


> This sounds like a known issue that has been fixed for 3.7-rc1.
> As a workaround, try to pass position_fix=2 option to snd-hda-intel
> module.

Thanks a lot, that parameter fixed it for me. It was not necessary before,
and I'll try to remove it again for 3.7

Helge Hafting
