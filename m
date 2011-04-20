Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1DTBe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 21:34:56 -0400
Received: from [62.121.20.90] ([62.121.20.90]:33003 "EHLO relay.timico.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab1DTBey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 21:34:54 -0400
X-Greylist: delayed 85612 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Apr 2011 21:34:54 EDT
From: Jon Povey <Jon.Povey@racelogic.co.uk>
To: Ben Gardiner <bengardiner@nanometrics.ca>
CC: "Nori, Sekhar" <nsekhar@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Griffis, Brad" <bgriffis@ti.com>, Philby John <pjohn@in.mvista.com>
Content-Class: urn:content-classes:message
Date: Wed, 20 Apr 2011 02:34:47 +0100
Subject: RE: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Thread-Topic: [PATCH 0/6] i2c-davinci gpio pulsed SCL recovery with ICPFUNC
Thread-Index: Acv+jAlcdplzwpLCT9uvYJdDdBb8dAAbtzsg
Message-ID: <70E876B0EA86DD4BAF101844BC814DFE093FB40BBD@Cloud.RL.local>
In-Reply-To: <BANLkTinTMi76GmgO6HJ0+ifCXsHE3Mjsvg@mail.gmail.com>
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
> In "i2c-davinci: Fix race when setting up for TX" and "i2c-davinci:
> Fix TX setup for more SoCs" you mention testing on DM355 -- is there
> any you have hardware on which the recovery procedure is executed on
> occasion and that you would be available to test modifications to the
> current implementation?

Nope, sorry. I've never seen the bus lock up.

--
Jon Povey
jon.povey@racelogic.co.uk

Racelogic is a limited company registered in England. Registered number 2743719 .
Registered Office Unit 10, Swan Business Centre, Osier Way, Buckingham, Bucks, MK18 1TB .

The information contained in this electronic mail transmission is intended by Racelogic Ltd for the use of the named individual or entity to which it is directed and may contain information that is confidential or privileged. If you have received this electronic mail transmission in error, please delete it from your system without copying or forwarding it, and notify the sender of the error by reply email so that the sender's address records can be corrected. The views expressed by the sender of this communication do not necessarily represent those of Racelogic Ltd. Please note that Racelogic reserves the right to monitor e-mail communications passing through its network


