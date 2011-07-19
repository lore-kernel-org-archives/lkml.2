Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1GSGx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 02:53:29 -0400
Received: from fallback.mail.timico.net ([62.121.11.168]:54921 "EHLO
	fallback.mail.timico.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab1GSGx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 02:53:28 -0400
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jul 2011 02:53:27 EDT
From: Jon Povey <Jon.Povey@racelogic.co.uk>
To: "Hadli, Manjunath" <manjunath.hadli@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Class: urn:content-classes:message
Date: Tue, 19 Jul 2011 07:28:19 +0100
Subject: RE: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Topic: [PATCH] davinci: fix DM365 EVM video input mux bits
Thread-Index: AcxFxEO6UigcFyPiSea2qTqvKwuHFAAD90YgAAItJbA=
Message-ID: <70E876B0EA86DD4BAF101844BC814DFE0B4E0859D7@Cloud.RL.local>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB593024BCEF73E@dbde02.ent.ti.com>
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

Hadli, Manjunath wrote:
> Jon,
>
> The fix looks correct. As a part of a different
> implementation which will go soon upstream, this has been
> taken care of, where we have used macros
> CPLD_VIDEO_INPUT_MUX_TVP7002    0x1
> CPLD_VIDEO_INPUT_MUX_IMAGER     0x2
>
> So, if you can do the same, it will look better.

If you have a patch you can split out that has your defines
where and how you want them then great.

Otherwise I'd suggest just getting this or something equivalent
in to fix the bug first, and reimplement it later.

--
Jon Povey
jon.povey@racelogic.co.uk

Racelogic is a limited company registered in England. Registered number 2743719 .
Registered Office Unit 10, Swan Business Centre, Osier Way, Buckingham, Bucks, MK18 1TB .

The information contained in this electronic mail transmission is intended by Racelogic Ltd for the use of the named individual or entity to which it is directed and may contain information that is confidential or privileged. If you have received this electronic mail transmission in error, please delete it from your system without copying or forwarding it, and notify the sender of the error by reply email so that the sender's address records can be corrected. The views expressed by the sender of this communication do not necessarily represent those of Racelogic Ltd. Please note that Racelogic reserves the right to monitor e-mail communications passing through its network


