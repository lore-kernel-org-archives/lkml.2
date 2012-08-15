Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2HOC0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 22:26:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:43357 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2HOC0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 22:26:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,770,1336374000"; 
   d="scan'208";a="134398316"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: [PATCH] smb347_charger: fix battery status reporting logic for
 charger faults
Thread-Topic: [PATCH] smb347_charger: fix battery status reporting logic for
 charger faults
Thread-Index: AQHNeSuX3V/qill4cUOXMv3jvrxHA5daKCqA
Date: Wed, 15 Aug 2012 02:26:37 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD224814@BGSMSX102.gar.corp.intel.com>
References: <1342792368-8346-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120813081617.GA2649@intel.com>
In-Reply-To: <20120813081617.GA2649@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Fri, Jul 20, 2012 at 07:22:48PM +0530, Ramakrishna Pallala wrote:
> > This patch checks for charger status register for determining the
> > battery charging status and reports Discharing/Charging/Not
> > Charging/Full accordingly.
> >
> > This patch also adds the interrupt support for Safety Timer Expiration.
> > This interrupt is helpful in debugging the cause for charger fault.
> >
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> 
> Few nitpicks below, otherwise looks good to me.

Thanks for the comments. I will fix them.

Thanks,
Ram

