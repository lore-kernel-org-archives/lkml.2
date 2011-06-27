Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1F0HG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:06:58 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:52364 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab1F0HFW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:05:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAF8qCE6Q/khM/2dsb2JhbABSp0N3iHShSZ0yhjAElnqLJg
X-IronPort-AV: E=Sophos;i="4.65,431,1304294400"; 
   d="scan'208";a="39385899"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3] Add support for the Philips SA56004 temperature sensor.
Date: Mon, 27 Jun 2011 09:04:46 +0200
Message-ID: <6E4D2678AC543844917CA081C9D6B33F04CF4FFC@XMB-AMS-103.cisco.com>
In-Reply-To: <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3] Add support for the Philips SA56004 temperature sensor.
Thread-Index: Acw0OuLD9ts8TCMfSEa2rhYj8TtcwgAXWa+Q
References: <1307356845-10095-1-git-send-email-sdevrien@cisco.com> <BANLkTi=gAqpDNBjCXzvNEhSuzm=3Mg9rVg@mail.gmail.com>
From: "Stijn Devriendt (sdevrien)" <sdevrien@cisco.com>
To: "Fubo Chen" <fubo.chen@gmail.com>
Cc: <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <guenter.roeck@ericsson.com>
X-OriginalArrivalTime: 27 Jun 2011 07:05:20.0938 (UTC) FILETIME=[93FC98A0:01CC3498]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Jun 6, 2011 at 12:40 PM,  <sdevrien@cisco.com> wrote:
> > +       } else
> > +       if (man_id == 0xA1) { /*  NXP Semiconductor/Philips */
> 
> No kernel coder writes like this. Has this ever been run through
> checkpatch ?
It has. Unfortunately this is just the coding style in the whole
driver. I believe it's better to have a consistent file rather
than 3 different styles.

Stijn

