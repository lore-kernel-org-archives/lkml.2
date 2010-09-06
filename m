Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0IFKoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 06:44:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56930 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750929Ab0IFKoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 06:44:54 -0400
Date: Mon, 6 Sep 2010 11:44:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Jiri Slaby <jslaby@suse.cz>, tiwai@suse.de, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Liam Girdwood <lg@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@suse.cz>
Subject: Re: [PATCH 1/1] SOUND: wm8753, remove dead code
Message-ID: <20100906104452.GF10367@rakim.wolfsonmicro.main>
References: <1283605929-15961-1-git-send-email-jslaby@suse.cz>
 <1283769150.3078.15.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283769150.3078.15.camel@odin>
X-Cookie: Welcome to the Zoo!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:32:30AM +0100, Liam Girdwood wrote:
> On Sat, 2010-09-04 at 15:12 +0200, Jiri Slaby wrote:
> > There is adangling code in wm8753_probe which is never executed.
> > Remove it.
> > 
> > Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Jiri, you should know to send copies of patches to maintainers.  Applied
after digging out of a list folder.
