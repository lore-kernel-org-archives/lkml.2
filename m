Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab0JGPQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:16:00 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:43121 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760681Ab0JGPP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:15:58 -0400
Subject: RE: RFC: btusb firmware load help
From: Johannes Berg <johannes@sipsolutions.net>
To: Shanmugamkamatchi Balashanmugam 
	<Shanmugamkamatchi.Balashanmugam@Atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
        Marcel Holtmann <holtmann@linux.intel.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Deepak Dhamdhere <Deepak.Dhamdhere@Atheros.com>,
        Sree Durbha <Sree.Durbha@Atheros.com>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com>
References: <1286349552.6145.11.camel@aeonflux>
	 <AANLkTimDvgFtoGLEjgWyYRrhQy6Num-rn_2WYO4Lf84b@mail.gmail.com>
	 <1286380566.6145.42.camel@aeonflux> <20101006163816.GE7070@tux>
	 <AANLkTik9w4_PdcEsbRHakLcxcD334_1Q8hGArxTXPCGF@mail.gmail.com>
	 <20101006173949.GG7070@tux>
	 <1286387660.3655.382.camel@jlt3.sipsolutions.net>
	 <AANLkTikYRSQw-+Tcj4VS1qxi=OaeF9C5hjAMWVu+0M=v@mail.gmail.com>
	 <AANLkTi=o4Mc72NrNoALBdS3YHeY7RMyyAJPsCy=uW3+F@mail.gmail.com>
	 <1286389697.3655.401.camel@jlt3.sipsolutions.net>
	 ,<20101006183340.GI7070@tux>
	 <44EE5C37ADC36343B0625A05DD408C4850DAD2CA31@CHEXMB-01.global.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 17:15:55 +0200
Message-ID: <1286464555.20974.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks Johannes.  This would be better option to change PID in firmware
> as blacklisting 3002 might create problems for 3011 chipsets.

What would be the problem with 3011? Does it also use the 3002 ID, but
not use firmware upload???

johannes

