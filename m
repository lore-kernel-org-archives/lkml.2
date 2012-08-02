Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab2HBKhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:37:00 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:26817 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2HBKg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:36:59 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [NEW DRIVER V1 0/7] please comment on this new PMIC driver
Thread-Topic: [NEW DRIVER V1 0/7] please comment on this new PMIC driver
Thread-Index: AQHNcIvGdwktYfpHg0esQavR/KQa4JdGPiOAgAAT1JA=
Date: Thu, 2 Aug 2012 10:36:55 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032BFC7A@NB-EX-MBX02.diasemi.com>
References: <201208020849.q728ng3f007799@latitude.olech.com>
 <20120802101718.GF29157@opensource.wolfsonmicro.com>
In-Reply-To: <20120802101718.GF29157@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.21.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Mark,

for your very helpful comments on all on the patches in this first submission attempt, I will digest and regurgitate a second attempt as soon as I can.

best regards,

Tony Olech

-----Original Message-----
From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
Sent: 02 August 2012 11:17
To: Opensource [Anthony Olech]
Cc: LKML
Subject: Re: [NEW DRIVER V1 0/7] please comment on this new PMIC driver

On Thu, Aug 02, 2012 at 09:48:58AM +0100, Anthony Olech wrote:
> This is submission attempt number 1 to have this driver included in 
> the linux kernel source tree. This is the driver for the Dialog DA9058.

I just noticed that you haven't CCed the maintainers for most of this stuff on your patches...  you should always do this if you want review.
