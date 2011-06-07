Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117Ab1FGUwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 16:52:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:35263 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab1FGUwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 16:52:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,334,1304319600"; 
   d="scan'208";a="13161427"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Matt_Domsch@dell.com" <Matt_Domsch@dell.com>
Date: Tue, 7 Jun 2011 13:52:32 -0700
Subject: RE: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Topic: [PATCH v2 3/3] efi: Add support for using efivars as a pstore
 backend
Thread-Index: AcwlUQkoMH4e44QMT4GG6hxTwdZvnQAAwS0w
Message-ID: <987664A83D2D224EAE907B061CE93D5301E70D8F43@orsmsx505.amr.corp.intel.com>
References: <1307470562-15633-1-git-send-email-mjg@redhat.com>
 <1307470562-15633-4-git-send-email-mjg@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E70D8EAE@orsmsx505.amr.corp.intel.com>
 <20110607202517.GA732@srcf.ucam.org>
In-Reply-To: <20110607202517.GA732@srcf.ucam.org>
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

> Mm. Given that the name of the source is in the file, there's no 
> namespacing issues. In an ideal world I think we'd register all of them 
> in order to provide a better chance of at least one of them ending up in 
> actual persistent storage.

It depends on your level of paranoia - and on what problems
you think might occur. In an ideal world all the back-ends
would work - and we'd just use one until it filled up, and
then move to the next.  in the real world one of the back-ends
might just randomly hang the system - converting a crashing
system into a hung system (which many people consider a more
severe problem). Giving a user an opt-out method for a back-end
looks good in that scenario.

-Tony
