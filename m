Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2DTAsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 20:48:11 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:53554 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab2DTAsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 20:48:08 -0400
Date: Fri, 20 Apr 2012 00:21:08 +0100
From: Ken Moffat <zarniwhoop@ntlworld.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [ 06/41] PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120419232108.GB26147@milliways>
References: <20120316233829.GA14022@kroah.com>
 <20120316233811.136320350@linuxfoundation.org>
 <20120331032356.GA6664@milliways>
 <20120331033306.GA2475@burratino>
 <CA+55aFy2WdyeBc0j77UAjisThrm2ZDbC7O1O05kiOeBeiP1KZQ@mail.gmail.com>
 <20120331183246.GA14437@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120331183246.GA14437@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wom5GMh1gUkA:10 a=2EL98pTPio4A:10 a=uObrxnre4hsA:10 a=IkcTkHD0fZMA:10 a=pGLkceISAAAA:8 a=TSbVqHtbAAAA:8 a=9Rt4o3Z7AAAA:8 a=cxfNNUmnIO_nY3ziWWAA:9 a=QEXdDO2ut3YA:10 a=MSl-tDqOz04A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 07:32:46PM +0100, Matthew Garrett wrote:
> On Sat, Mar 31, 2012 at 11:20:41AM -0700, Linus Torvalds wrote:
> > On Fri, Mar 30, 2012 at 8:33 PM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> > >
> > > You might enjoy the following patch:
> > >
> > >  http://thread.gmane.org/gmane.linux.kernel.pci/14503
> > 
> > Yes, good. I guess I should just take it and not wait for Bjorn, since
> > we really need this for stable too. Matthew?
> 
> Works for me.
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

 Belatedly doing a reply to all - just found this thread in
/var/mail after my mbox overflowed.  Anyway, thanks.

ĸen
-- 
das eine Mal als Tragödie, das andere Mal als Farce
