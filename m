Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1IUQk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:40:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41552 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab1IUQkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:40:25 -0400
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Date: Wed, 21 Sep 2011 18:40:00 +0200
In-Reply-To: <20110921160409.GE6063@erda.amd.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
	 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
	 <20110921100842.GA6063@erda.amd.com> <20110921140432.GP5795@redhat.com>
	 <20110921151829.GC6063@erda.amd.com> <1316619232.24750.2.camel@twins>
	 <20110921160409.GE6063@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316623200.24750.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 18:04 +0200, Robert Richter wrote:
> No, I am trying to explain this...

D'uh, I got the b2b case inverted.. you're right.
