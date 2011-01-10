Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1AJNw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 08:52:27 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:22341 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1AJNwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 08:52:25 -0500
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 08:52:25 EST
X-Spam-Processed: mail.digidescorp.com, Mon, 10 Jan 2011 07:44:50 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=19910c6f74=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: CPU Initiated DMA
From: "Steven J. Magnani" <steve@digidescorp.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4D28A9EF.3050400@gmail.com>
References: <87mxncv3ge.fsf@inspiron.ap.columbia.edu>
	 <4D28A9EF.3050400@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Jan 2011 07:44:45 -0600
Message-ID: <1294667085.3139.3.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-08 at 12:16 -0600, Robert Hancock wrote:
> On 01/07/2011 02:55 PM, Nikolaus Rath wrote:
> > Hello,
> >
> > I want to write a driver for a rather dumb PCI card, which cannot become
> > bus master itself. Is it possible to use a DMA controller on the
> > mainboard to still transfer data to the card without occupying the CPU?
> >
> > (I believe this is the way DMA used to work on ISA cards, but do recent
> > x86 systems still have a DMA controller for the CPU?)
> 
> The legacy ISA DMA controller worked like that, but you can't use that 
> with PCI devices. Essentially there is no way to do this, barring 
> perhaps some wierd platform specific feature.

I believe a DMA Engine would work here - platform-specific, yes, but I
wouldn't call it "wierd"  :)

See Documentation/dmaengine.txt.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



