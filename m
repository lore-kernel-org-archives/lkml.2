Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1ENNCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 09:02:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1ENNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 09:02:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t3IZTUxUw8i0LJJ4vIcpDbqqD9mZr3sh7r8fovXYZBsDDI5Ja0bZR98Ct4gsZu/Lyi
         Yr8bzo+BmQo1OibijYHofl1EkUD4Ixgtq78am+5r7j4vtzT7ue74po7VB0/WHu+MpIwa
         SgBE8Qtx2BSe2MXhC7uNlqu8+yl7ZTj1hXxJU=
Date: Sat, 14 May 2011 15:02:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] perf: Carve out cgroup-related code
Message-ID: <20110514130241.GA1729@nowhere>
References: <1305121600.2914.214.camel@laptop>
 <20110511140208.GD25827@aftab>
 <20110511141342.GA19053@elte.hu>
 <20110511143149.GA26548@aftab>
 <20110511152156.GA21707@elte.hu>
 <20110511170912.GA27362@aftab>
 <1305190277.2914.259.camel@laptop>
 <20110512101839.GA17731@aftab>
 <20110512143148.GB7410@nowhere>
 <20110514084450.GA2073@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110514084450.GA2073@aftab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 10:44:50AM +0200, Borislav Petkov wrote:
> On Thu, May 12, 2011 at 10:31:52AM -0400, Frederic Weisbecker wrote:
> > > Ok, I won't be able to redo the patches before Mo. due to travel. Also,
> > > I think that you should do the splitting, as I suggested so at the
> > > beginning!
> > 
> > I can take it if you want. I'm currently splitting the buffer
> > part so I can try to relay the rest as well :)
> 
> Hey Frederic,
> 
> yeah, sure, go ahead.
> 
> I can take over your preso at LinuxTag instead, if you'd like :)

Sure, please do ;)
