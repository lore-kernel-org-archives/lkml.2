Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab2EEKmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:42:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:46020 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2EEKmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139221997"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@iki.fi>
Subject: RE: [PATCH v2] smb347_charger: Cleanup power supply registration
 code in probe
Thread-Topic: [PATCH v2] smb347_charger: Cleanup power supply registration
 code in probe
Thread-Index: AQHNHl/WbV8uvtA/zUm/xFF6SyZHTZa7GlZg
Date: Sat, 5 May 2012 10:42:40 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD140012@BGSMSX102.gar.corp.intel.com>
References: <1334809818-5958-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120419190820.GB877@mwesterb-mobl.lan>
In-Reply-To: <20120419190820.GB877@mwesterb-mobl.lan>
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

Hi Anton,

> Subject: Re: [PATCH v2] smb347_charger: Cleanup power supply registration code in probe
> 
> On Thu, Apr 19, 2012 at 10:00:18AM +0530, Ramakrishna Pallala wrote:
> > This patch checks if the usb or mains charging is enabled by the
> > platform before registering with the power supply class.
> 
> I still don't like the idea of having the power-supplies registered conditionally. Now
> you need to check in every place whether the corresponding power-supply is registered or
> not which makes the code uglier and more prone to errors.

This patch needs your attention.

Thanks,
Ram
