Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0HZMlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 08:41:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42210 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502Ab0HZMlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 08:41:37 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "hiroshi.doyu@nokia.com" <hiroshi.doyu@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>
Date: Thu, 26 Aug 2010 07:38:26 -0500
Subject: RE: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Topic: [PATCH 8/9] dspbridge: add map support for big buffers
Thread-Index: ActE66MJpz6cfFNvSa6xQiR9X6bUgwAL/FTD
Message-ID: <496565EC904933469F292DDA3F1663E602F10ED4B1@dlee06.ent.ti.com>
References: <1277943660-4112-7-git-send-email-x0095840@ti.com>
	<1277943660-4112-8-git-send-email-x0095840@ti.com>
	<1277943660-4112-9-git-send-email-x0095840@ti.com>,<20100826155416J.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826155416J.fujita.tomonori@lab.ntt.co.jp>
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


Hi Fujita,
________________________________________
>From: FUJITA Tomonori [fujita.tomonori@lab.ntt.co.jp]
>Sent: Thursday, August 26, 2010 1:55 AM
>To: Guzman Lugo, Fernando
>Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; ohad@wizery.com; hiroshi.doyu@nokia.com; ameya.palande@nokia.com; felipe.contreras@nokia.com
>Subject: Re: [PATCH 8/9] dspbridge: add map support for big buffers
>
>On Wed, 30 Jun 2010 19:20:59 -0500
>Fernando Guzman Lugo <x0095840@ti.com> wrote:
>
>> due to a restriction in scatter gather lists, it can
>> not be created a list for a buffer bigger than 1MB.
>> This patch is spliting big mappings into 1MB mappings.
>
>I don't read the whole thread but the above description is incorrect.
>
>Why can't you use scatter gather chaining? You can create a scatter
>list for a buffer larger than 1MB.

The thing is that ARM architecture does not support SG chaining. This patch should be
seen like a workaround until it is fixed in iovmm module.

Thanks and regards,
Fernando.
