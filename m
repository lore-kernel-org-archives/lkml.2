Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab0KIRr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:47:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0KIRrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:47:55 -0500
Date: Tue, 9 Nov 2010 09:35:40 -0800
From: Greg KH <gregkh@suse.de>
To: mems applications <mems.applications@st.com>
Cc: carmine.iascone@st.com, matteo.dameno@st.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lis331dlh: add lis331dlh driver
Message-ID: <20101109173540.GA20370@suse.de>
References: <>
 <1289323527-5501-1-git-send-email-carmine.iascone@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289323527-5501-1-git-send-email-carmine.iascone@st.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 06:25:27PM +0100, mems applications wrote:
> Add STMicroelectronics LIS331DLH digital accelerometer device driver
> 
> From: Carmine Iascone <carmine.iascone@st.com>
> ---
>  drivers/staging/Kconfig               |    2 +
>  drivers/staging/Makefile              |    1 +
>  drivers/staging/lis331dlh/Kconfig     |    7 +
>  drivers/staging/lis331dlh/Makefile    |    1 +
>  drivers/staging/lis331dlh/lis331dlh.c |  836 +++++++++++++++++++++++++++++++++
>  drivers/staging/lis331dlh/lis331dlh.h |   83 ++++
>  6 files changed, 930 insertions(+), 0 deletions(-)

Why is this a staging driver?  What is keeping it from being merged to
the main portion of the kernel tree?

Can you please provide a TODO file that lists the things left to do on
it, and provide some email addresses to contact you for it?  Look at the
other TODO files in drivers/staging/*/TODO for examples.

thanks,

greg k-h
