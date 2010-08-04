Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab0HDKYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:24:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42990 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab0HDKYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:24:31 -0400
Subject: Re: A question of perf NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
In-Reply-To: <20100804100116.GH26154@erda.amd.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
	 <20100804100116.GH26154@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 12:24:18 +0200
Message-ID: <1280917458.1923.937.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 12:01 +0200, Robert Richter wrote:
> To ensure that all other nmi handlers are
> called, the perfctr's nmi handler must have the lowest priority. Then,
> the handler will be the last in the chain. 

Well, unless another NMI handler has the exact same issue and also
starts eating all NMIs, just in case.
