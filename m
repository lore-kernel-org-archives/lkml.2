Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab0LBJDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 04:03:49 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42939 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367Ab0LBJDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 04:03:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=C9xyMldZbZisituBHIlWjoMtZdUZ169tq0zQGx27ZX8xvUEtm6bdm465h7+X0vHe13
         Vkq753mE92+MCeb0TRG//IJvrAapxc9/HkE2GCLylRE1bXhu5YIyg1pcfw/bLiZuYSoO
         YH0MwQo9usn2oKHtDii/FCoU3NF+ypua1yjlk=
Subject: Re: edac_core: crashes on shutdown
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101201193508.GA4916@liondog.tnic>
References: <1291201307.3029.21.camel@Tobias-Karnat>
	 <20101201123921.GA15530@a1.tnic> <1291209888.12511.11.camel@Tobias-Karnat>
	 <20101201143329.GB18074@a1.tnic> <1291225614.8646.4.camel@Tobias-Karnat>
	 <20101201193508.GA4916@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:03:33 +0100
Message-ID: <1291280613.10626.22.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 01.12.2010, 20:35 +0100 schrieb Borislav Petkov:
> Hmm, I see two backtraces now. I'm still not sure whether the first
> one is actually the first one that happens since it is cut off at the
> beginning.
> 
> If it is the first one, it should contain something like
> 
> [ ... ] Pid: ... , comm: ... Not tainted <kernel version> <DMI system name>
> 
> the important part being the "Not tainted" string. Can you check that
> please?

I only can get an oops with the end cut off or two oopses with the
beginning cut off.

But here is an oops with the "Not tainted" string:

http://oi52.tinypic.com/21nqwky.jpg

> Also, can you disable the EDAC subsystem in Kconfig and retry?
> I'm trying to rule out some other issue since the backtraces are
> inconclusive wrt EDAC.
> 
> Thanks.

Yes, maybe on the weekend, but as I said replacing the modules with
compiled from older src does work fine.

-Tobias

