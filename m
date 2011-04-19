Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1DSCdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 22:33:49 -0400
Received: from fallback.mail.timico.net ([62.121.11.168]:43921 "EHLO
	fallback.mail.timico.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1DSCdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 22:33:45 -0400
X-Greylist: delayed 2512 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Apr 2011 22:33:45 EDT
From: Jon Povey <Jon.Povey@racelogic.co.uk>
To: Ben Gardiner <bengardiner@nanometrics.ca>, "Nori, Sekhar" <nsekhar@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bastian Ruppert <Bastian.Ruppert@sewerin.de>,
        "Griffis, Brad" <bgriffis@ti.com>, Philby John <pjohn@in.mvista.com>
Content-Class: urn:content-classes:message
Date: Tue, 19 Apr 2011 02:47:53 +0100
Subject: RE: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Thread-Topic: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Thread-Index: Acv+EJ38iH3RAWm0Ql2hvEXDsbMa3AAIpVUg
Message-ID: <70E876B0EA86DD4BAF101844BC814DFE093FB40998@Cloud.RL.local>
In-Reply-To: <BANLkTi=7DbMrbo0nQU+268LC_2258q-_DA@mail.gmail.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gardiner wrote:

>>> When creating this series I noticed that there are obvious
>>> similarities between the existing recovery routine implemented by
>>> Philby John and John Povey

> I'm not sure how the 20us in the existing method was derived -- I
> wonder if Philby John or John Povey could comment?

I've been a little bemused about why I am getting credited for I2C
bus recovery work. I don't remember doing any work on that.

I did a couple of patches to fix a race when setting up a TX, but
those are, afaik, unrelated.

All I know about the bus recovery stuff is looking at it a while back
and thinking hmm, that seems to wiggle gpio without changing the
pinmuxing, so it can't possibly work.

--
Jon Povey
jon.povey@racelogic.co.uk

Racelogic is a limited company registered in England. Registered number 2743719 .
Registered Office Unit 10, Swan Business Centre, Osier Way, Buckingham, Bucks, MK18 1TB .

The information contained in this electronic mail transmission is intended by Racelogic Ltd for the use of the named individual or entity to which it is directed and may contain information that is confidential or privileged. If you have received this electronic mail transmission in error, please delete it from your system without copying or forwarding it, and notify the sender of the error by reply email so that the sender's address records can be corrected. The views expressed by the sender of this communication do not necessarily represent those of Racelogic Ltd. Please note that Racelogic reserves the right to monitor e-mail communications passing through its network


