Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0FTUF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:05:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37220 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756988Ab0FTUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=LEWhnk8b8kik9LMtpGDXTG0MaHZLaDYo06mq96kzNge4bBg+5q93DOPVSVPngrABke
         ClsMlrOUxeTh5LsO8xztp8MWK0M/udIRdnLESkvJpTegXv1p2chJBInsqJvjvqbDZj4B
         kVIq07+NSpMl/4KlL7gG+6KqqaDCqTz5DxXc0=
Date: Sun, 20 Jun 2010 13:02:39 -0700
From: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>
To: John Sheehan <john.d.sheehan@gmail.com>
Cc: Charles =?iso-8859-1?Q?Cl=E9ment?= <caratorn@gmail.com>, gregkh@suse.de,
       wfp5p@virginia.edu, rich.folsom@gmail.com, mithlesh@linsyssoft.com,
       jirislaby@gmail.com, john.d.sheehan@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: comedi: fix style errors in adl_pci9111.c
Message-ID: <20100620200238.GA31748@fujitsu>
References: <1276713009-8499-1-git-send-email-john.d.sheehan@gmail.com>
 <20100616192803.GA11073@fujitsu>
 <AANLkTil0ezKl6SbtvGe0Vn_d6RX789NMAnwvRKheDUaK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTil0ezKl6SbtvGe0Vn_d6RX789NMAnwvRKheDUaK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:33:36AM +0100, John Sheehan wrote:
> Hi Charles,
> 
> 2010/6/16 Charles Clément <caratorn@gmail.com>:
> > Hi,
> >
> > On Wed, Jun 16, 2010 at 07:30:09PM +0100, John Sheehan wrote:
> >> From: John Sheehan <john.d.sheehan@gmail.com>
> >
> >> @@ -190,7 +190,7 @@ TODO:
> >>    outb(flags, PCI9111_IO_BASE+PCI9111_REGISTER_TRIGGER_MODE_CONTROL)
> >>
> >>  #define pci9111_interrupt_and_fifo_get() \
> >> -  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4) &0x03)
> >> +  ((inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_MODE_INTERRUPT_READBACK) >> 4)&0x03)
> >
> > Doesn't checkpatch.pl suggest to add a whitespace after the & in that case?
> 
> no, surprisingly enough, it just requires the amount of whitespace at
> either side of the & to be consistent

Any specific reason to take this off the list?

> 
> John
> > It would seem more readable.
> >
> > --
> > Charles Clément
> >
> >

-- 
Charles Clément

