Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1CSJ2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 05:28:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1CSJ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sI38Atl6r3RwKS/hKR97CEOS5fWY2R8AVCLyWj4SS7FjbMdRcFtKVYg1CrYc66obzg
         sOs7XY4n0OS1Ior8F944cvxMKe61RwPgdPeflMKsyeVVrWkEJ83EPZdZLX53h9ugNN4i
         nD4rNztYHyuM6JTn0DVy4/2Raae2/tTjOT4f8=
Date: Sat, 19 Mar 2011 10:28:12 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: 2.6.39 crashes BUG: unable to handle kernel NULL pointer
 dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55 under Xen as PV
 guest.
Message-ID: <20110319092812.GB11644@riccoc20.at.omicron.at>
References: <20110318203830.GA9262@dumpdata.com>
 <1300485566.2731.46.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300485566.2731.46.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 02:59:26PM -0700, John Stultz wrote:
> No new job, I'm still at IBM. Just a new email address, as I'm working
> as part of the Linaro effort. My old address still work too, and I'll
> continue to use them for non-Linaro work.

John,

You might want to double check whether your old IBM email account
really still works. Some time ago one of my lkml postings with you on
CC did bounce back to me with "no such account" or something like
that.

Richard
