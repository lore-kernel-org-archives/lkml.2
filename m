Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab2FFXHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:07:37 -0400
Received: from relay.ihostexchange.net ([66.46.182.58]:49661 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093Ab2FFXHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:07:35 -0400
From: "Shai Fultheim (Shai@ScaleMP.com)" <Shai@ScaleMP.com>
To: Ido Yariv <ido@wizery.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 6 Jun 2012 19:07:33 -0400
Subject: RE: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Thread-Topic: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Thread-Index: Ac1EOO/COCClpbhgRhKQHLeXHBnS9AAAAzAQ
Message-ID: <9B14D1490DDECA4E974F6B9FC9EBAB317EEFC74FE5@VMBX108.ihostexchange.net>
References: <1334873492-31255-1-git-send-email-ido@wizery.com>
 <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
 <1339003443.23343.6.camel@twins>
 <9B14D1490DDECA4E974F6B9FC9EBAB317EEFC74FD0@VMBX108.ihostexchange.net>
 <20120606230544.GA25288@WorkStation.localnet>
In-Reply-To: <20120606230544.GA25288@WorkStation.localnet>
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

Ido Yariv [mailto:ido@wizery.com] wrote:

> The synthetic CPUID bit approach has the advantage of setting this bit
> from the platform initialization code independently (in this case, in
> vsmp_64.c) instead of calling platform specific functions from
> pageattr.c (such as is_vsmp_box()) or exporting the static_key variable.
> 
> We'll give this a shot and send a revised patch after testing it.
> 
> Sounds good?

I can support that.  Let's get this ready.
