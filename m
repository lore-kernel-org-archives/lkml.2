Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab0LTS23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:28:29 -0500
Received: from void.printf.net ([89.145.121.20]:38233 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab0LTS21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:28:27 -0500
From: Chris Ball <cjb@laptop.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: sedat.dilek@gmail.com, Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ftpadmin@kernel.org
Subject: Re: linux-next: Tree for December 20
References: <AANLkTi=gjHyMt=W4-+PSMzt7PN7i-_Yvmx7EE8z0z74q@mail.gmail.com>
	<20101220230007.e82487b8.sfr@canb.auug.org.au>
Date: Mon, 20 Dec 2010 13:34:09 -0500
In-Reply-To: <20101220230007.e82487b8.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 20 Dec 2010 23:00:07 +1100")
Message-ID: <m3pqswe1jy.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   >>> [The mirroring on kernel.org is running slowly]

   >> Indeed, you know what's wrong with the mirrors?

   > I don't know what is wrong.  The mirroring just seems to be much
   > slower in the last week or so.  Today, it was just over three
   > hours from when I uploaded linux-next until it was mirrored out.

I asked on IRC yesterday; we're still under high load from the Android
Gingerbread release, which is causing many concurrent Git accesses
(around 1500 simultaneous yesterday).

Thanks,

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
