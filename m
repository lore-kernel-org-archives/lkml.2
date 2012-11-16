Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab2KPTuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 14:50:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54928 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2KPTuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 14:50:13 -0500
Date: Fri, 16 Nov 2012 11:50:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Alexandra Chin <Alexandra.Chin@tw.synaptics.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>,
        Mahesh Srinivasan <msrinivasan@synaptics.com>,
        Alex Chang <alex.chang@tw.synaptics.com>,
        Scott Lin <scott.lin@tw.synaptics.com>,
        Christopher Heiny <Cheiny@synaptics.com>
Subject: Re: [PATCH v6] staging: ste_rmi4: Convert to Type-B support
Message-ID: <20121116195008.GA9153@kroah.com>
References: <20121103013623.0f3a1b28168a9a42881b0b00@tw.synaptics.com>
 <20121116163146.f4b53f6965ee08ca1a1fc96c@tw.synaptics.com>
 <20121116195433.GA573@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121116195433.GA573@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 08:54:33PM +0100, Henrik Rydberg wrote:
> Hi Alexandra,
> 
> > Convert to MT-B because Synaptics touch devices are capable
> > of tracking identifiable fingers.
> > 
> > Signed-off-by: Alexandra Chin <alexandra.chin@tw.synaptics.com>
> 
> For next time: Once you have received an acked-by or reviewed-by, you
> may add that line under your own signed-off-by in subsequent
> mails. That way, the status of the patch can be tracked properly,
> making life easier for everyone.
> 
> Greg, I think we are ready now. :-)

All applied.
