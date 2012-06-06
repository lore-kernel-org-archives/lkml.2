Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab2FFEt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:49:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44870 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab2FFEtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:49:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [RFC] clean up headers for light drivers : backlights, leds and
 iio-light
Thread-Topic: [RFC] clean up headers for light drivers : backlights, leds
 and iio-light
Thread-Index: Ac1DMebzgj+NhOPmQCOPkZnXWmi9vP//xpYA//7rKiA=
Date: Wed, 6 Jun 2012 04:49:43 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998FAE54@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998FAD86@DQHE02.ent.ti.com>
 <20120605201738.GC27297@kroah.com>
In-Reply-To: <20120605201738.GC27297@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.108.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lots of those can move to include/linux/platform_data/ today, which
> would clean up things a lot.  Care to do that first and see what is
> left
> over and is really needed here?

OK, I'll keep tracking first.
Thanks for your opinion.

Best Regards,
Milo -
