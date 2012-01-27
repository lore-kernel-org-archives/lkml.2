Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab2A0PHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:07:10 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39776 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab2A0PHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:07:09 -0500
X-Sasl-enc: UnLaE08qAHuDBjkGENprn5KFTa4UKAiCWtr5uTNCTp98 1327676828
Date: Fri, 27 Jan 2012 06:56:00 -0800
From: Greg KH <greg@kroah.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Long term stable kernel seletion (3.0)
Message-ID: <20120127145600.GA4259@kroah.com>
References: <CAJ8eaTwfYvAEUXX=LMFfHvvyG1JKT4wADqofb0YdyaUtDT8GEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8eaTwfYvAEUXX=LMFfHvvyG1JKT4wADqofb0YdyaUtDT8GEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:54:42AM +0530, naveen yadav wrote:
> Dear All,
> 
> Recently Greg decide and select linux 3.0 for long term.
> 
> http://www.kroah.com/log/
> 3.0.y - this is the new "longterm" kernel release, it will be
> maintained for 2 years at the minimum by me.
> 
> PS. Catalin+ Greg
> So I have one request from Mr. Catalin and Greg.
> 
> Is ARM-15 support will be added in this or not. ?

No new features get added to stable or longterm supported kernels,
please see the rules for what gets added to these kernels in the file,
Documentation/stable_kernel_rules.txt.

So if it isn't there already, it's not going to be, sorry.

greg k-h
