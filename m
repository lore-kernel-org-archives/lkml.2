Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab1CDGqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 01:46:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53990 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1CDGq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 01:46:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XwZwgnB+N3iYGjHgQSGgBiLKYpA74e8dZgOMsLMNocecoFzvVAROoIJh8Hs/bxKBjB
         DvWEKhaSMyd5VTH7/+LZdWNKjpOUPWpFEq5fBh0ZCku00wYvlQ2UMBaVMyogGolj6zd7
         fGE5vxRCU4S9e/C35vQiiej/iBt7yxIIOM8YM=
Date: Fri, 4 Mar 2011 07:46:39 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110304064639.GD3824@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <1299180844.28285.111.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299180844.28285.111.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 11:34:04AM -0800, john stultz wrote:
> On Thu, 2011-03-03 at 18:26 +0100, Torben Hohn wrote:
> > First version of a software clock. Not very useful yet,
> > as it doesnt generate events, but at least it allows
> > for testing the ptp framework without special hardware.
> 
> So in the past, I pushed back on Richard for having something similar,
> as I'm not psyched about duplicating interfaces. However, your
> implementation is CLOCK_MONOTONIC_RAW instead of CLOCK_REALTIME and it
> keeps the adjustments internal, I'm not as opposed.

(Aha! So it is okay after all ;)

I do think a software only PHC will make it easier for people to get
started with the new interface. I have been carrying along such a
patch privately for my own testing.

Thanks,

Richard
