Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab2JWQ5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:57:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:4610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933203Ab2JWQ5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:57:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,637,1344236400"; 
   d="scan'208";a="209566489"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kees Cook <keescook@chromium.org>,
        "Tirdea, Irina" <irina.tirdea@intel.com>
CC: Anton Vorontsov <cbouatmailru@gmail.com>, Colin Cross <ccross@android.com>,
        Chris Ball <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hunter, Adrian" <adrian.hunter@intel.com>,
        "Purdila, Octavian" <octavian.purdila@intel.com>
Subject: RE: [PATCH 02/26] pstore: add flags
Thread-Topic: [PATCH 02/26] pstore: add flags
Thread-Index: AQHNsSRCgPU4i2VyLE+VKGQKhO7lLpfHkUEA//+K6xA=
Date: Tue, 23 Oct 2012 16:57:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D58DE9@ORSMSX108.amr.corp.intel.com>
References: <1351000104-13015-1-git-send-email-irina.tirdea@intel.com>
	<1351000104-13015-3-git-send-email-irina.tirdea@intel.com>
 <CAGXu5jKEuMyDhZB4QDLq9yZLQFjXMq2hXhTEToMyQ_rXwc4TZw@mail.gmail.com>
In-Reply-To: <CAGXu5jKEuMyDhZB4QDLq9yZLQFjXMq2hXhTEToMyQ_rXwc4TZw@mail.gmail.com>
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

> I wonder if the default should be to not show headers, and to add this
> flag to the backends that want the pstore-added header. I think the
> more common case going forward will to be without headers since
> backends should arguably storing metadata themselves.

Perhaps just add the headings when pstore breaks a dump into
pieces because of a back-end size limitation. I.e. if there is only
one piece, then no headings. If there are two or more, include
a heading to aid with putting the pieces together later.

-Tony
