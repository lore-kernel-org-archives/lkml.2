Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043Ab2CaOTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 10:19:45 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:65054 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab2CaOTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 10:19:42 -0400
From: Arkadiusz =?utf-8?q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] proc: reset mount options after the last procfs umount
Date: Sat, 31 Mar 2012 16:19:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.0-06972-ge22057c; KDE/4.8.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
References: <201203220903.15360.a.miskiewicz@gmail.com> <20120326153738.aa728115.akpm@linux-foundation.org> <20120331135520.GB2845@albatros>
In-Reply-To: <20120331135520.GB2845@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201203311619.38921.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 of March 2012, Vasiliy Kulikov wrote:
> On Mon, Mar 26, 2012 at 15:37 -0700, Andrew Morton wrote:
> > On Sun, 25 Mar 2012 18:23:16 -0400
> > 
> > Valdis.Kletnieks@vt.edu wrote:
> > > Yes, it may be what the code actually *does*, but it certainly violates
> > > the Principle of Least Surprise...
> > 
> > It surprises me ;)  I never noticed that before.
> > 
> > It does seem pretty insane.  I wonder how much downstream damage would
> > result from fixing it.
> 
> Resetting options on each mount is implemented in the following patch.

"after all procs are umounted". For me such way is fine but still can suprise 
people.


Anyway - what's the problem with implementing support for separate options for 
each mount point?

> I wonder whether anybody will try to do such parallel type of things
> in reality (IOW, is it OK to leave this race?)

I mount multiple procs when using linux-vserver but these are currently not 
happening in parallel (but could be).

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
