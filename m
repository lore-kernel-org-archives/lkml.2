Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab0IOLBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 07:01:06 -0400
Received: from galiil.marvell.com ([199.203.130.254]:35449 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0IOLBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 07:01:05 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 07:01:04 EDT
From: Saeed Bishara <saeed@marvell.com>
To: Chris Ball <cjb@laptop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 15 Sep 2010 12:55:33 +0300
Subject: RE: [PATCH] mmc: Add architecture dependency for Marvell SoC
	controller
Thread-Topic: [PATCH] mmc: Add architecture dependency for Marvell SoC
	controller
Thread-Index: ActUuf/628n8u/YdTq+MH8r1ViEY6AACkAhg
Message-ID: <FCBE654890C0334289D0AD3AF4EF009FD18EE74AA8@IL-MB01.marvell.com>
References: <1284366279-17140-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20100914190549.GA21918@void.printf.net>
 <20100915094006.GA21620@sirena.org.uk>
In-Reply-To: <20100915094006.GA21620@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com] 
>Sent: Wednesday, September 15, 2010 11:40 AM
>To: Chris Ball
>Cc: Saeed Bishara; Andrew Morton; linux-mmc@vger.kernel.org; 
>linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] mmc: Add architecture dependency for 
>Marvell SoC controller
>
>On Tue, Sep 14, 2010 at 08:05:49PM +0100, Chris Ball wrote:
>
>> This is fine with me.  Saeed, please can you ACK the choice of
>> platforms if you agree?
>
>If the list of platforms is wrong we should probably also improve the
>help text :)
I think the PLAT_PXA it too general, maybe you better specify the exact ARCH (ARCH_MMP).
saeed
>