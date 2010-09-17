Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab0IQHwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 03:52:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:55083 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab0IQHwa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 03:52:30 -0400
Subject: Re: [PATCH] x86: fix duplicate calls of the nmi handler
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lin, Ming M" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "eranian@google.com" <eranian@google.com>
In-Reply-To: <1284682396.32373.16.camel@yhuang-dev>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
	 <1284118900.402.35.camel@laptop> <20100910132741.GB4879@redhat.com>
	 <20100910144634.GA1060@elte.hu>  <20100910155659.GD13563@erda.amd.com>
	 <1284658950.2275.591.camel@laptop>  <1284682396.32373.16.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Sep 2010 09:52:16 +0200
Message-ID: <1284709936.3764.2241.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-17 at 08:13 +0800, Huang Ying wrote:

> Please take a look at my recent patch that rewrites the NMI handler.

(Link would have been useful)

> Where NMI are divided into two types. CPU specific NMI are processed
> firstly as DIE_NMI_IPI, and non-CPU specific NMI are processed as
> DIE_NMI.

OK, and you can discriminate between these two by means of that reason
port? Still I think NMI_IPI is a terrible name for that.


