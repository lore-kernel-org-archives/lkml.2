Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1BURSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 12:18:24 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53094 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab1BURSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 12:18:22 -0500
Date: Mon, 21 Feb 2011 19:18:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbi@ti.com, David Cohen <dacohen@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221171818.GN23087@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
 <1298299131-17695-2-git-send-email-dacohen@gmail.com>
 <1298303677.24121.1.camel@twins>
 <AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com>
 <1298305245.24121.7.camel@twins>
 <20110221162939.GK23087@legolas.emea.dhcp.ti.com>
 <1298306607.24121.18.camel@twins>
 <20110221165443.GL23087@legolas.emea.dhcp.ti.com>
 <1298307962.24121.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298307962.24121.27.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 06:06:02PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-02-21 at 18:54 +0200, Felipe Balbi wrote:
> 
> > What you seem to have missed is that sched.h doesn't include wait.h, it
> > includes completion.h and completion.h needs wait.h due the
> > wait_queue_head_t it uses.
> 
> Yeah, so? sched.h doesn't need completion.h, but like with wait.h I'd
> argue the other way around, completion.h would want to include sched.h

ok, now I get what you proposed. Still, we could have lived without the
sarcasm, but that's not subject to patching.

-- 
balbi
