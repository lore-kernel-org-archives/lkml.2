Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab2LQN6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:58:12 -0500
Received: from smtp1.uu.se ([130.238.7.54]:34381 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab2LQN6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:58:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20687.9425.163651.172293@pilspetsen.it.uu.se>
Date: Mon, 17 Dec 2012 14:57:37 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "devendra.aaru" <devendra.aaru@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.7.0 regression] rt2x00lib_probe_dev: Error - Failed to
 initialize hw
In-Reply-To: <CAL1gcdMyx4y0TeSRi+5oG6cpULPXGu+i8E0ej3-6+n9pt8qPSw@mail.gmail.com>
References: <20686.63778.840426.61474@pilspetsen.it.uu.se>
	<CAHdPZaPQNQ1WS5Qkb4FpmmOX7mXL10HsdaXf5dctp2hd2T0Sow@mail.gmail.com>
	<20687.3736.365327.811519@pilspetsen.it.uu.se>
	<CAHdPZaNOK=isKPZtxYaBFsGvcpN0261wExaXgRYjg5N3Y7qJZg@mail.gmail.com>
	<CAL1gcdMyx4y0TeSRi+5oG6cpULPXGu+i8E0ej3-6+n9pt8qPSw@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gertjan van Wingerde writes:
 > Mikael, Devendra,
 > 
 > On Mon, Dec 17, 2012 at 1:59 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
 > > On Mon, Dec 17, 2012 at 7:22 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
 > >> devendra.aaru writes:
 > >>  > On Mon, Dec 17, 2012 at 5:51 AM, Mikael Pettersson <mikpe@it.uu.se> wrote:
 > >>  > > I just updated an old 1st gen AMD64 laptop from kernel 3.6.0 to 3.7.0,
 > >>  > > Fedora 15 user-space, and was greeted by the following kernel warning:
 > >>  > >
 > >>  > > WARNING: at net/wireless/core.c:389 wiphy_register+0x5c3/0x600 [cfg80211]()
...
 > This is caused by the introduction of interface combinations. Helmut
 > Schaa has already submitted a patch to fix this, but this has
 > unfortunately not ended up in 3.7. I'm confident it will end up in one
 > of the upcoming 3.7.x stable releases.
 > 
 > See http://marc.info/?l=linux-wireless&m=135478723823922&w=2 for the
 > patch submitted by Helmut.

That patch fixes the problem.  Thanks.

/Mikael
