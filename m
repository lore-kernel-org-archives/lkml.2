Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1IWBkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:40:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64195 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1IWBkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:40:12 -0400
Date: Fri, 23 Sep 2011 09:40:02 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 33/55] infiniband: irq: Remove IRQF_DISABLED
Message-ID: <20110923014002.GA21500@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1316681962-8217-1-git-send-email-yong.zhang0@gmail.com>
 <1316681962-8217-34-git-send-email-yong.zhang0@gmail.com>
 <CAL1RGDWoNpFyTi5PaA8sfsEts4GLm_LzPC+tTmu6EPbkndx=NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL1RGDWoNpFyTi5PaA8sfsEts4GLm_LzPC+tTmu6EPbkndx=NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 09:56:07AM -0700, Roland Dreier wrote:
> Is someone taking this whole series, or should I take the ehca part?

You could take it and Thomas will take the leftovers.

> (I know the ehca guys already acked this)

Yeah, so I mentioned it in the cover letter :)

Thanks,
Yong
