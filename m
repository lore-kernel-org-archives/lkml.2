Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0FZLdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 07:33:07 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:43815 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab0FZLdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 07:33:06 -0400
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jun 2010 07:33:05 EDT
Date: Sat, 26 Jun 2010 13:25:04 +0200
From: =?iso-8859-1?Q?Sh=E9rab?= <Sebastien.Hinderer@ens-lyon.org>
To: Matthew Ranostay <mranostay@embeddedalley.com>,
       Takashi Iwai <tiwai@suse.de>, PeiSen Hou <pshou@realtek.com.tw>,
       matt.jared@intel.com, andy.kopp@intel.com, dan.d.kogan@intel.com,
       Jaroslav Kysela <perex@perex.cz>, Wu Fengguang <fengguang.wu@intel.com>,
       Daniel T Chen <crimsun@ubuntu.com>,
       Lydia Wang <lydiawang@viatech.com.cn>, alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: PC Beeps not working with HDA Intel module
Message-ID: <20100626112504.GA3365@pema>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

The problem is on a computer with an HDA Intel sound card, Intel G45
DEVCTG chip and appears will all version s of the kernel.

Running e.g.
beep 440
produces a beep whose audible frequency is very low, definitely not 440
Hz.

However, it is worth notiing that grub is able to produce a beep of the
right frequency at boot time.

Can this problem be fixed ?

Should you need any additional bit of information or testing, please ask.

Many thanks in advance for your help,
Shérab.
