Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2A0OZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:25:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58996 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380Ab2A0OZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:25:45 -0500
Date: Fri, 27 Jan 2012 14:25:24 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Greg KH <greg@kroah.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Long term stable kernel seletion (3.0)
Message-ID: <20120127142524.GD7757@arm.com>
References: <CAJ8eaTwfYvAEUXX=LMFfHvvyG1JKT4wADqofb0YdyaUtDT8GEg@mail.gmail.com>
 <20120127112434.GA7757@arm.com>
 <CAJ8eaTzqZSuvDd2yVHSP1AydxHzjGkNgLP2KX7wSxyZ--DBZRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTzqZSuvDd2yVHSP1AydxHzjGkNgLP2KX7wSxyZ--DBZRA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 01:17:41PM +0000, naveen yadav wrote:
> we do not want to use LPAE featue and virtulisation feature of cortex -A15,
>  then still I need generic timers  ?. or they are used in virtulasiation ..

The generic timers are useful on SMP as that's the only way to get local
timers on A15. Otherwise, just use a global timer and IPIs (they are
also useful in a virtualised environment but that depends on the
hypervisor).

-- 
Catalin
