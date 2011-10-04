Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab1JDQoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:44:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:39567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932898Ab1JDQoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:20 -0400
Subject: Re: [V7][PATCH 0/6] x86, nmi: new NMI handling routines
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Don Zickus <dzickus@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Date: Tue, 04 Oct 2011 18:43:15 +0200
In-Reply-To: <20111004150531.GH21506@erda.amd.com>
References: <1317409584-23662-1-git-send-email-dzickus@redhat.com>
	 <1317657158.20367.30.camel@twins> <20111003155655.GG5795@redhat.com>
	 <1317657548.20367.33.camel@twins> <20111004150531.GH21506@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317746595.32543.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 17:05 +0200, Robert Richter wrote:
> On 03.10.11 11:59:08, Peter Zijlstra wrote:
> > I didn't need that, I build an allnoconfig (which got me a fail with the
> > IBS patches), then an allyesconfig (which got me the earlier fail) and
> > this came from my regular config which included the ipmi crap because
> > Ingo hit this same fail earlier (-v5 or so) and everybody forgot to tell
> > you :/
> 
> A change like the one below should fix the IBS build breakage (for
> perf, x86: Implement IBS initialization).

Right, that's what I did.

