Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab1EaKEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 06:04:38 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:36786 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1EaKEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 06:04:37 -0400
Date: Tue, 31 May 2011 12:04:34 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Very high CPU values in top on idle system (3.0-rc1)
Message-ID: <20110531100434.GA1759@x4.trippels.de>
References: <20110530173916.GA1746@x4.trippels.de>
 <1306778743.23844.5.camel@twins>
 <20110530182356.GA1762@x4.trippels.de>
 <20110530204548.GA1762@x4.trippels.de>
 <1306793579.2530.2.camel@twins>
 <1306835745.2353.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306835745.2353.3.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.05.31 at 11:55 +0200, Peter Zijlstra wrote:
> On Tue, 2011-05-31 at 00:12 +0200, Peter Zijlstra wrote:
> > 
> > I poked around with some skip_rq_update bits but couldn't make it go
> > away, will try more tomorrow.
> 
> Gah, that was annoying, and explains why I wasn't seeing it on my main
> dev box but could see it on my desktop (wsm tsc is much better synced
> than the core2 tsc).
> 
> Could you confirm that this indeed cures the problem?

Yes, indeed it does. Many thanks Peter.

-- 
Markus
