Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1BWAHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:07:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:42866 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab1BWAHl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:07:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,209,1297065600"; 
   d="scan'208";a="392612371"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mike Waychison <mikew@google.com>, Greg KH <greg@kroah.com>
CC: Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Tue, 22 Feb 2011 16:07:32 -0800
Subject: RE: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Thread-Topic: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Thread-Index: AcvS6J77td6Dk+3VSViyoKNiDFau7gABOiSQ
Message-ID: <987664A83D2D224EAE907B061CE93D53019D6606DB@orsmsx505.amr.corp.intel.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
 <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com>
 <20110217215608.GA2451@kroah.com> <4D644736.9050109@google.com>
In-Reply-To: <4D644736.9050109@google.com>
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

>Looks to be supported on ia64 as well, though I don't have any hardware 
>to test this code on for that arch.  Tony: I think this DMI exporting 
>code should just work on ia64 as all it is using is dmi_walk() and 
>parsing the entries as returned as dmi_headers in the callback.  Does 
>this sound sane to you?

Yes we have dmi on ia64 too.

-Tony
