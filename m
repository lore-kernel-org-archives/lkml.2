Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab1EQUEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:04:05 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39839 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140Ab1EQUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:04:03 -0400
Date: Tue, 17 May 2011 22:03:23 +0200
From: Borislav Petkov <bp@amd64.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>,
        Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.38.6 -stable regression: kernel insta-death on boot.
Message-ID: <20110517200323.GA1344@aftab>
References: <20110514195741.GA10757@elliptictech.com>
 <201105172049.44684.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105172049.44684.maciej.rutecki@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 02:49:44PM -0400, Maciej Rutecki wrote:
> On sobota, 14 maja 2011 o 21:57:42 Nick Bowler wrote:
> > 2.6.38.6 panics almost immediately on boot.  2.6.38.3 works fine.  Full
> > kernel log and bisection results follow.  Reverting the implicated
> > commit corrects the issue.
> 
> I created a Bugzilla entry at 
> https://bugzilla.kernel.org/show_bug.cgi?id=35272
> for your bug report, please add your address to the CC list in there, thanks!

I've posted fixes for that at

http://marc.info/?l=linux-kernel&m=130563697911265

and Nick is also on CC. Nick, it would be nice if you could confirm that
they actually fix the issue for you.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
