Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1HVPl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:41:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab1HVPl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:41:27 -0400
Date: Mon, 22 Aug 2011 11:41:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110822154117.GF2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <1314022429.24275.30.camel@twins>
 <20110822152154.GB2067@redhat.com>
 <1314026812.24275.67.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314026812.24275.67.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 05:26:52PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-22 at 11:21 -0400, Don Zickus wrote:
> > 
> > Sure.  Well there are a few drivers that want to register.  Unless you
> > want to make a rule that all nmi handlers have to be built-in? 
> 
> Well, I'm all for that, but I guess I'm going to loose that particular
> fight ;-)

:-)  I don't care either way, but from a technical point of view, you
would have trouble with getting oprofile as a built-in I would think.

Cheers,
Don

