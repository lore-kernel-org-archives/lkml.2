Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab1D2I0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 04:26:38 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:50386 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab1D2I0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 04:26:34 -0400
Date: Fri, 29 Apr 2011 10:26:23 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Igor Plyatov <plyatov@gmail.com>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>, linuxpps@ml.enneenne.com,
        linux-kernel@vger.kernel.org
Message-ID: <20110429082623.GN11227@gundam.enneenne.com>
Mail-Followup-To: Igor Plyatov <plyatov@gmail.com>,
	Alexander Gordeev <lasaine@lvk.cs.msu.su>, linuxpps@ml.enneenne.com,
	linux-kernel@vger.kernel.org
References: <1303928054-14662-3-git-send-email-jamesnuss@nanometrics.ca> <20110428152222.0271163f@apollo.gnet> <BANLkTimG0vL3Ky=ARa+7XyW4PSFdg064YQ@mail.gmail.com> <20110429005524.67600139@apollo.gnet> <20110429012748.704a39a6@apollo.gnet> <4DBA3EC3.2020209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBA3EC3.2020209@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [LinuxPPS] [PATCH 2/2] pps: new client driver using IRQs
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 08:29:55AM +0400, Igor Plyatov wrote:

>>> The latter will definitely mess things up, right?
>> I mean, one surely can register an IRQ resource with both flags set. And
>> if the underlying hardware works as it is described (i.e. raises an irq
>> on both edges) then it will be a problem.
>
> Please don't try to abandon one of ASSERT or CLEAR events!
> It is very useful to register both of them, because in this case its  
> possible to measure pulse width and decode PPS signals like DCF77.

At this point I suppose we should add both ASSERT and CLEAR events...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
