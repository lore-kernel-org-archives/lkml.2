Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2ARWiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:38:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:37155 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab2ARWiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:38:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="108471070"
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>
CC: Marco Stornelli <marco.stornelli@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5] ramoops: use pstore interface
Thread-Topic: [PATCH v5] ramoops: use pstore interface
Thread-Index: AQHM1XUTvkd48sBDKkeD64dAtx+V3JYTNe6A//96tMA=
Date: Wed, 18 Jan 2012 22:37:45 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F01D107@ORSMSX104.amr.corp.intel.com>
References: <20120117235852.GA4877@www.outflux.net>
 <20120118140603.0fc22302.akpm@linux-foundation.org>
In-Reply-To: <20120118140603.0fc22302.akpm@linux-foundation.org>
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

> > +	/* TODO(kees): We cannot unload ramoops since pstore doesn't support
> > +	 * unregistering yet.
> > +	 */
>
> Well that sucks.  Is pstore getting fixed?

While it might be useful for developers who have machines that
support multiple back-ends to load & unload - there really isn't
any credible end-user case for it - so it has a very low priority.
Perhaps zero (it would complicate the code for no useful purpose).

Even for development there's a lot of re-booting (after all, pstore
is really about saving the kernel log when the system crashes :-).

-Tony
