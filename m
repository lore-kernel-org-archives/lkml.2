Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab2GEUD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:03:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:1430 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228Ab2GEUDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:03:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173860589"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Topic: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Thread-Index: Ac1ZdICAdYwUKctERYa3qDPOlfZeVABeLqqAAAEWsxA=
Date: Thu, 5 Jul 2012 20:03:40 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1934755B@ORSMSX104.amr.corp.intel.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <20120705133201.GG5637@redhat.com>
In-Reply-To: <20120705133201.GG5637@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>     - In case where an existing entry is oops/shutdown/halt/poweroff
>>       -  It is erasable if an error ,panic, emergency or oops, happen in new event.
>>            - Oops is erasable because system may still be running and its message may be saved 
>>              into /var/log/messages.
>
> Then why save it to begin with?

It would be useful in the case where an OOPS is followed quickly by a system hang.

-Tony
 
