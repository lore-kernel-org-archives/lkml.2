Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031282Ab2COB3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:29:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61191 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760704Ab2COB3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:29:45 -0400
Date: Thu, 15 Mar 2012 01:29:41 +0000
From: Motiejus =?utf-8?Q?Jak=C5=A1tys?= <desired.mta@gmail.com>
To: Vasco Dias <rafa.vasco@gmail.com>, linux-kernel@vger.kernel.org,
        mikew@google.com
Cc: Matt Fleming <matt@console-pimps.org>
Subject: Re: Problem with efibootmgr on asus 1215b
Message-ID: <20120315012941.GA24251@pierce>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312143806.GB12382@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Somewhat late to this I know, but:
> 
> On Fri, Jan 20, 2012 at 11:48:26AM +0000, Matt Fleming wrote:
> > [  441.370854] BUG: unable to handle kernel paging request at 00000000ffe1fbc8
> 
> So it's attempting a direct access to 00000000ffe1fbc8, which, if I had 
> to guess, is probably where the flash is located. That makes sense from 
> the perspective of it being used in efivars. The obvious sadness here is 
> that it's doing this with a physical address rather than a virtual one.
> It's possible that the machine is too broken to live - does Windows 
> succeed in performing a UEFI install? If it does then I think we need to 
> just accept that life is ugly and map the UEFI runtime areas with a 1:1 
> mapping as well as into virtual address space. That would also fix the 
> problem we see right now where the reboot call often uses a physical 
> address rather than a virtual one.

Just to let you know I apparently have exactly the same issue with the same
laptop. If it can help, I could try installing the M$ Student Edition during
the weekend and report the results.

Windows Server 2008 64-bit, fresh GPT partition table will be my lab
environment. Standard installation procedure.

I am running Ubuntu 12.04 with 3.2.0-18-generic.

Motiejus
