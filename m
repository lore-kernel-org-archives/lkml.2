Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1GHOhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:37:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038Ab1GHOhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:37:40 -0400
Date: Fri, 8 Jul 2011 07:35:40 -0700
From: Greg KH <gregkh@suse.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Drunkard Zhang <gongfan193@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Huang Ying <ying.huang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: 2.6.39.2: duplicate filename '/devices/platform/GHES.9' on Asus
 DSBV-D
Message-ID: <20110708143540.GA20891@suse.de>
References: <CAJiejCSObv6d2EULVnCufGMHsLacSi-g2o9gbs8p0MYoYMVgJg@mail.gmail.com>
 <20110708134003.GA5041@suse.de>
 <20110708142453.GA15256@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708142453.GA15256@gere.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 04:24:53PM +0200, Borislav Petkov wrote:
> On Fri, Jul 08, 2011 at 06:40:03AM -0700, Greg KH wrote:
> > On Fri, Jul 08, 2011 at 04:02:27PM +0800, Drunkard Zhang wrote:
> > > On newly updated kernel I found this. I'm not sure it's a BIOS bug or
> > > kernel bug. More infomation attached. I can gather more infomation if
> > > you want :)
> > 
> > It's an acpi issue, care to send it to that mailing list?
> 
> We had this issue already: http://lkml.org/lkml/2010/9/17/116 - I
> guess the fix wasn't complete. And yes, it is a BIOS bug but the
> kernel shouldn't OOPS just because BIOS programmers fell asleep on the
> keyboard.

It's not oopsing, sysfs is spitting out a warning and then continuing
on, after failing to create the directory.

greg k-h
