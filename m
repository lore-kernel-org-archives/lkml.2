Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab2JXUa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:30:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab2JXUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:30:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH 2/2] arm: mvebu: Add hardware I/O Coherency support
Date: Wed, 24 Oct 2012 20:30:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jon Masters <jcm@redhat.com>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com> <201210241224.06791.arnd@arndb.de> <5087F38B.1010508@free-electrons.com>
In-Reply-To: <5087F38B.1010508@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210242030.09959.arnd@arndb.de>
X-Provags-ID: V02:K0:nskvqXLGqWdw89mU8p0xtVzW4s59iyy8GqJf0mmnh7E
 yc4VqQvsZezppwxhOar5mMyRSBd1IxxVOYfN9X0beSRuzOGmq0
 4KDv5QROkMiNQiROU5WtVCiY3x429DVr8kRMysuu4NPLc6SLf2
 +WpuA13ztXy81Wv8x4ZJb7Hwx+nxCkT82HyyAVuJhPmxLGorCg
 SUqtFS+Yof6/kR4REPoIgqgQxtpxxTMBC86Q/9Hd4ePtajxpH7
 2iLeXYrFMTc3g70/IZjdvIxUcbCx1CU8qElcctk89ySwrF6bhW
 TtLy5BP9qSK+qwrydE7w9uq2587BkkTLyAzGElfD6R2XlfKvu/
 lgyb2BETf+5AO9lgUn5o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2012, Gregory CLEMENT wrote:
> > No, I was thinking of making the underlying functions globally visible
> > and have extern declarations in a header file so you can access them
> > directly.
> > 
> > Generally speaking, when you run into a problem with common code, your
> > first approach should be to fix the common code before you try to work
> > around it.
> 
> OK I thought it was done on purpose. But if you consider it needs to be
> fixed I will add patch for it in next version.

As long as the functions were only used locally in one file, it's
better not to make them globally visible as a rule. But if we know
that they are needed, that should be made explicit. Please fix this
by submitting another patch to make those functions global and then
rebase this series on top of that.

	Arnd
