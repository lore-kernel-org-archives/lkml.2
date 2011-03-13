Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1CMK2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 06:28:54 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:35305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755191Ab1CMK13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 06:27:29 -0400
Date: Sun, 13 Mar 2011 11:27:17 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Rick Jones <rick.jones2@hp.com>
Cc: Tianji Li <Tianji.Li@nuim.ie>, Dave T?ht <d@taht.net>,
        sedat.dilek@gmail.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, bloat-devel@lists.bufferbloat.net,
        linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
Message-ID: <20110313102716.GC1827@ucw.cz>
References: <AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
 <87fwr9jxya.fsf@cruithne.co.teklibre.org>
 <AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
 <8739n9ii7z.fsf@cruithne.co.teklibre.org>
 <AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
 <87tyfph2az.fsf@cruithne.co.teklibre.org>
 <1299176168.2157.14.camel@tardy>
 <4D6FEFD4.9010608@nuim.ie>
 <20110308065819.GA1357@ucw.cz>
 <1299610096.2087.8.camel@tardy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299610096.2087.8.camel@tardy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Bandwidth varies greatly with time. On cellphone, you can go from
> > 5KB/sec GPRS to 300KB/sec HSDPA and back...
> 
> How quickly/often and does that trigger an event in the host that would
> allow adjustment of the queue?

I'd expect it to get fast when you leave the building, and back to
slow when you re-enter. It all depends how good 3G coverage is, but
seeing it change more than once a minute is not that uncommon.

Event... not sure. Linux can ask for current signal strength, and I
assume connection type works in similar way...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
