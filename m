Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0CQXUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 19:20:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:63544 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0CQXUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 19:20:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,261,1267430400"; 
   d="scan'208";a="549980248"
Subject: Re: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "holt@sgi.com" <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <ff8c11be-b22d-4849-9b19-d9107c4fea47@email.android.com>
References: <ff8c11be-b22d-4849-9b19-d9107c4fea47@email.android.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 17 Mar 2010 16:19:18 -0800
Message-Id: <1268871558.2696.60.camel@sbs-t61.fm.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 12:51 -0700, H. Peter Anvin wrote:
> Well, as you know :) tglx and I are on the road ... I'll try to get to it on Friday before I take off again.

Also I talked to Thomas about this rwlock conversion and he referred to
RT issues with rwlock. And the best is to avoid this using RCU.

For now, the second patch can be perhaps dropped, as we are being
proactive anyways. We can revisit this in the future.

First patch "[patch 1/2] x86,pat Update the page flags for memtype
atomically instead of using memtype_lock. -V3" is good to go.

thanks,
suresh

