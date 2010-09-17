Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab0IQHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:09:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:43942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0IQHJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:09:56 -0400
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
In-Reply-To: <AANLkTimuG3N-qPvB-af=afgJbo5aVBCd6ozxkLFNz78K@mail.gmail.com>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com>
	 <20100910144634.GA1060@elte.hu> <20100910155659.GD13563@erda.amd.com>
	 <1284658950.2275.591.camel@laptop>
	 <AANLkTimuG3N-qPvB-af=afgJbo5aVBCd6ozxkLFNz78K@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Sep 2010 09:09:38 +0200
Message-ID: <1284707378.3764.2173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 22:18 +0200, Stephane Eranian wrote:
> 
> Why not just have one level, NMI, and use the priority field to position
> handlers correctly? 

My point exactly.. I just don't know the history of this code, I had a
quick peek at git but it seems to predate .12, I'll try and dig through
the hysterical tree later today.


