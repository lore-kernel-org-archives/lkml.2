Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2AMOSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 09:18:13 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:58368 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab2AMOSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 09:18:12 -0500
Date: Fri, 13 Jan 2012 15:18:09 +0100
From: Nico Schottelius <nico-linux-20120113@schottelius.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Nico Schottelius <nico-linux-20120113@schottelius.org>,
        LKML <linux-kernel@vger.kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: brcmsmac: 3.2.0-06100: no device shown (and hangs in 3.2.0-rc7)
Message-ID: <20120113141809.GA3072@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20120113@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>, b43-dev@lists.infradead.org,
	netdev@vger.kernel.org
References: <20120113124559.GA2260@schottelius.org>
 <4F103379.2050904@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F103379.2050904@broadcom.com>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: brief (Linux 3.2.0-06100-ge343a89 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Arend,

Arend van Spriel [Fri, Jan 13, 2012 at 02:36:57PM +0100]:
> Could this be on your MacBook Air? If so, Linus has flagged and solved
> this issue (see thread "brcm80211 breakage" on netdev mailer).

Oh, yes, indeed!

Although the channel 13 issue seems still to exist.

I'll apply his patches this evening and test as well.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
