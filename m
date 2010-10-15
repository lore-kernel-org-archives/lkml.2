Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0JOGNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 02:13:41 -0400
Received: from ra.se.axis.com ([195.60.68.13]:34544 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0JOGNk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 02:13:40 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Kyle McMartin <kyle@mcmartin.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jesper Nilsson <jespern@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Date: Fri, 15 Oct 2010 08:13:36 +0200
Subject: RE: [PATCH 0/4] cris: kill __do_IRQ
Thread-Topic: [PATCH 0/4] cris: kill __do_IRQ
Thread-Index: ActsJ4FSiKARN1ReTfajgGOx0mp/nAACFyQw
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D05583DC035FC@xmail3.se.axis.com>
References: <20101015040127.GA6333@bombadil.infradead.org>
In-Reply-To: <20101015040127.GA6333@bombadil.infradead.org>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great! These patches were expected and we would have done it ourselves someday soon but it is always great to
get help from others, Thanks for caring about CRIS!

We will test these patches as soon as possible

Regards
/Mikael

-----Original Message-----
From: Kyle McMartin [mailto:kyle@infradead.org] On Behalf Of Kyle McMartin
Sent: den 15 oktober 2010 06:01
To: linux-kernel@vger.kernel.org
Cc: Mikael Starvik; Jesper Nilsson; linux-cris-kernel; kyle@mcmartin.ca
Subject: [PATCH 0/4] cris: kill __do_IRQ

Hi,

The following patches remove the cris architectures calls to __do_IRQ.
They've been build tested on -v10 and -v32, but not boot tested. It
should be possible to bisect across the changes for both platforms.

 arch/cris/Kconfig                     |    3 ++
 arch/cris/arch-v10/kernel/irq.c       |   26 +++-------------
 arch/cris/arch-v32/kernel/irq.c       |   53 +++++++++------------------------
 arch/cris/include/arch-v32/arch/irq.h |    4 +-
 arch/cris/kernel/irq.c                |    2 +-
 5 files changed, 25 insertions(+), 63 deletions(-)

regards, Kyle M.
