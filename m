Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab0JHKbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:31:09 -0400
Received: from smtp.nokia.com ([147.243.1.47]:23928 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab0JHKbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:31:07 -0400
Subject: RE: [PATCH] bdi: use deferable timer for sync_supers task
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: "Wu, Xia" <xia.wu@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Yong Wang <yong.y.wang@linux.intel.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <A24AE1FFE7AEC5489F83450EE98351BF227AB58D51@shsmsx502.ccr.corp.intel.com>
References: <20101008083514.GA12402@ywang-moblin2.bj.intel.com>
	 <20101008092520.GB5426@lst.de>
	 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D43@shsmsx502.ccr.corp.intel.com>
	 <1286532586.2095.55.camel@localhost>
	 <A24AE1FFE7AEC5489F83450EE98351BF227AB58D51@shsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Fri, 08 Oct 2010 13:28:07 +0300
Message-ID: <1286533687.2095.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 18:27 +0800, Wu, Xia wrote:
> > However, when the next wake-up interrupt happens is not defined. It can
> > happen 1ms after, or 1 minute after, or 1 hour after. What Christoph
> > says is that there should be some guarantee that sb writeout starts,
> > say, within 5 to 10 seconds interval. Deferrable timers do not guarantee
> > this. But take a look at the range hrtimers - they do exactly this.
> 
> If the system is in sleep state, is there any data which should be written?

May be yes, may be no.

>  Must 
> sb writeout start even there isn't any data? 

No.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

