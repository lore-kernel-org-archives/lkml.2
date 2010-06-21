Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab0FUVpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 17:45:47 -0400
Received: from kroah.org ([198.145.64.141]:41599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab0FUVpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 17:45:46 -0400
Date: Mon, 21 Jun 2010 14:18:08 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Andreas Mohr <andi@lisas.de>,
       Radek Liboska <liboska@uochb.cas.cz>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi: correct merge conflict with CONTEC
 id
Message-ID: <20100621211808.GA25511@kroah.com>
References: <AANLkTimx1HWYzG0qQqP12ObWQI1eiH5SoFpRic06uN3f@mail.gmail.com>
 <20100618143727.GA16398@suse.de>
 <AANLkTinPDECqU-GYKpD7_2IHb2qKjhCnViXkPDqN_cpu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinPDECqU-GYKpD7_2IHb2qKjhCnViXkPDqN_cpu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:08:19AM +0900, Daniel Sangorrin wrote:
> Hi Greg,
> 
> I believe the merge problem occurred with the commit:
> 
> dee5658b482e9e2ac7d6205dc876fc11d4008138
> 
> Originally I submitted a patch and then they asked me to order the IDs
> and resubmit, so did I. But unfortunately in the end somehow both
> patches were merged.
> 
> [PATCH] USB: serial: ftdi: add CONTEC vendor and product id
> [PATCH resubmit] USB: serial: ftdi: add CONTEC vendor and product id
> 
> Was I supposed to do the resubmit patch in a way that would unpatch
> the first patch? Or is the word resubmit enough to know that this is
> the good patch?

This is good, I just wanted to know this information as to what went
wrong.  I'll put this into the changelog entry.

thanks,

greg k-h
