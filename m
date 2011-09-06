Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1IFE1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 00:27:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55361 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1IFE1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 00:27:37 -0400
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: david.wagner@free-electrons.com, linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 Sep 2011 07:29:51 +0300
In-Reply-To: <1315282208.19067.24.camel@sauron>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <201108241823.20904.arnd@arndb.de> <1314256010.18988.18.camel@sauron>
	 <201108251712.40894.arnd@arndb.de> <1315280704.19067.14.camel@sauron>
	 <1315282208.19067.24.camel@sauron>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315283397.19067.37.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 07:10 +0300, Artem Bityutskiy wrote:
> On Tue, 2011-09-06 at 06:44 +0300, Artem Bityutskiy wrote:
> > > It's not a dummy bus, in this approach it would be a the bus that gets
> > > used by all ubiblk devices, which is a very common concept by itself.
> > > It's more like the classic understanding of a 'device class' that Greg
> > > wants to see get replaced by bus_types in the kernel.
> > 
> > Yes, this sounds OK. Although UBI already has notifiers, so we could
> > just add 2 more events.
> 
> Hmm, with notifications the error handling becomes a problem - we want
> the ioctls for creating/removing the block device to be synchronous,
> and, should an error occur, we want to return the error code to the
> user-space. So the existing notifications mechanism does not work well.

... but we can change it a little and have error codes handling, this is
just UB implementation issues.

-- 
Best Regards,
Artem Bityutskiy

