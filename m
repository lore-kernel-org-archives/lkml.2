Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1ETMxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 08:53:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:45923 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753665Ab1ETMxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 08:53:32 -0400
X-Sasl-enc: pJvXZN2VousvBp5KMkau1mbl7yd7x73QVI4Z+/B4mEoY 1305896011
Date: Fri, 20 May 2011 05:53:59 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: matt mooney <mfm@muteddisk.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 01/12] staging: usbip: replace usbip_u{dbg,err,info} and
 printk with dev_ and pr_
Message-ID: <20110520125359.GA9857@kroah.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
 <2ecbb21cffe73acfe291c3c8e5626427ed5c5b43.1305866084.git.mfm@muteddisk.com>
 <20110520050101.GA7461@kroah.com>
 <BANLkTi=N9tAA_gZXgwDDTijyUuLysnQQEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=N9tAA_gZXgwDDTijyUuLysnQQEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:25:25PM -0700, matt mooney wrote:
> On Thu, May 19, 2011 at 10:01 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, May 19, 2011 at 09:36:55PM -0700, matt mooney wrote:
> >> This switches all of the usbip_u{dbg,err,info} and printk statements to
> >> dev_<level>, if possible, or pr_<level> macros. And removes a few
> >> unnecessary debug statements.
> >>
> >> Signed-off-by: matt mooney <mfm@muteddisk.com>
> >
> > I've already applied this one, right?
> 
> I don't think so. I never received a notification from your email bot ;)

Sorry, my bot went to sleep, you should have received it now.  If not,
please let me know and I'll see what happened.

thanks,

greg k-h
