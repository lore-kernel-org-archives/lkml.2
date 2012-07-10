Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab2GJSOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 14:14:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:13551 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2GJSOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 14:14:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120854611"
From: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
To: Joe Jin <joe.jin@oracle.com>
CC: "e1000-devel@lists.sf.net" <e1000-devel@lists.sf.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: 82571EB: Detected Hardware Unit Hang
Thread-Topic: 82571EB: Detected Hardware Unit Hang
Thread-Index: AQHNXbA0MFD+PEzbnUmyeAlZvKsVV5cimGMAgAA7P1A=
Date: Tue, 10 Jul 2012 18:14:23 +0000
Message-ID: <9BBC4E0CF881AA4299206E2E1412B62627502B8E@ORSMSX102.amr.corp.intel.com>
References: <4FFA9B96.6040901@oracle.com> <4FFBDC50.5090800@oracle.com>
In-Reply-To: <4FFBDC50.5090800@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: netdev-owner@vger.kernel.org [mailto:netdev-owner@vger.kernel.org]
>On Behalf Of Joe Jin
>Sent: Tuesday, July 10, 2012 12:40 AM
>To: Joe Jin
>Cc: e1000-devel@lists.sf.net; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: 82571EB: Detected Hardware Unit Hang
[..]
>I checked all driver codes I did not found anywhere will set the
>upper.data with
>E1000_TXD_STAT_DD, I guess upper.data be set by hardware?

Yes, the hw sets this bit after transmit, its how the driver knows to reclaim it.

>> Would you please help on this?

Yes, we'll attempt to reproduce it and get back to you with any more needed info.  I'm sorry you're having problems with our parts.

Thanks for the report,

Carolyn

Carolyn Wyborny
Linux Development
LAN Access Division
Intel Corporation


