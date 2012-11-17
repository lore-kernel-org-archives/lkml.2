Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2KQVYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:24:50 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52665 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2KQVYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:24:48 -0500
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 17 Nov 2012 13:24:26 -0800
X-Google-Sender-Auth: ImZN7LWmcVI6YH1UXMjspEjPbPM
Message-ID: <CAB=NE6WzzKLoBDhh4MR0-w+=-SuQnWEbvk_MzdNB6J=xuvb7DQ@mail.gmail.com>
Subject: Let her rip - compat-drivers box up and ready
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: Eric Searcy <eric@linuxfoundation.org>,
        Konstantin Ryabitsev <mricon@kernel.org>,
        "Philip J (Open Source Program Office) Robb" <phil.robb@hp.com>,
        Ann Davis <andavis@suse.com>,
        "Mike (SUSE BizDev) Nelson" <mike.nelson2@hp.com>,
        Joe Gerkman <JGerkman@suse.com>, Alan Clark <ACLARK@suse.com>,
        John Hawley <warthog19@eaglescrag.net>,
        Dan Stangel <dan.stangel@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to arrangements by the Linux Foundation, HP, and SUSE we now
have a suitable server we can share to help do compilation testing of
our work for compat-drivers which aims at automatically backporting
the Linux kernel down to all supported known kernel releases. HP
donated a server to the project for the Linux Foundation backporting
working group. Thanks to arrangements by SUSE, HP and Linux Foundation
the server is up and running now. The server this has shaven down
compilation for testing for the project across 23 kernels of
compat-drivers from 120 minutes down to 23 minutes for a compilation
of each kernel down to about one minute each, from 2.6.24 up to 3.6
and in synch up to the latest linux-next tag next-20121115.

As it we have enough memory to run everything in memory. All of
compat-ksrc code, linux-next, compat and compat-drivers git trees are
kept in memory. The box has 32 virtual CPUs and 234 GB of RAM. Right
now I've set up the /pub/mem directory to be shared and mounted 100 GB
of tmpfs there so that uses all RAM. I've dumped into there a copy of
/pub/local/* and upon reboot it copies all of /pub/local/* to
/pub/mem/. I've set the group there to be compat and added all of
active contributors to it.

As it is right now I think we have enough RAM to be able to create our
own tmpfs for each active developer. I think there is enough RAM and
CPU horse power to get each of us to run ckmake all at the same time
with 3 full copies of what we need. For further coordination lets do
so on IRC on #kernel-backports on irc.freenode.net.

Thanks so much to the Linux Foundation, SUSE, HP, and of course all
active contributors.

  Luis
