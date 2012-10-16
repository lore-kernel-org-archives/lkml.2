Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2JPHl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 03:41:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2JPHl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 03:41:56 -0400
MIME-Version: 1.0
In-Reply-To: <20121015164801.GA6458@kroah.com>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
	<2564763.3cNFlv543H@linux-lqwf.site>
	<CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
	<1921559.OPsFBnvatA@linux-lqwf.site>
	<CACVXFVM9bSX+iMx_7Z+S=HsNqNTpR0=qU3MeDQ1wD1LLM0UK-g@mail.gmail.com>
	<20121015164801.GA6458@kroah.com>
Date: Tue, 16 Oct 2012 15:41:54 +0800
Message-ID: <CACVXFVMeVu7h0S_3OMjSvkbntgudreqH4jnZSQrk766Q1WPLGQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus
 reset if storage interface exits
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:48 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> No, don't limit us for no good reason, that's not acceptable at all.
> Patching old kernels when new devices show up that work on those old
> kernels (like USB network devices that follow the spec with no driver
> change needed), is not a good idea.
>
> So I agree with Oliver here, this isn't acceptable.

OK, I will remove the limit in -v1 and add comments on the case.

thanks,
--
Ming Lei
