Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0J0RI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:08:59 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48353 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0J0RI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:08:58 -0400
Subject: Re: [PATCH -v3 3/6] x86, NMI, Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <20101027164522.GA25738@redhat.com>
References: <1286844650.7768.137.camel@yhuang-dev>
	 <1286863479.2336.1451.camel@twins> <1286864080.7768.179.camel@yhuang-dev>
	 <1286865071.2336.1478.camel@twins> <1286865447.7768.184.camel@yhuang-dev>
	 <1286865629.2336.1490.camel@twins> <1286865923.7768.188.camel@yhuang-dev>
	 <1286866193.2336.1503.camel@twins> <20101012135112.GE20436@basil.fritz.box>
	 <1286892927.29097.42.camel@twins>  <20101027164522.GA25738@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Oct 2010 19:08:44 +0200
Message-ID: <1288199324.3673.14.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-27 at 12:45 -0400, Don Zickus wrote:
> I assume this is sorta of what Peter was looking for.

Yeah close, except the prio field of the various notification blocks
need to get adjusted to preserve semantics.


