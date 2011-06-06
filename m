Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1FFPoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:44:37 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38411 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1FFPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:44:34 -0400
Date: Mon, 6 Jun 2011 16:44:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
Message-ID: <20110606154424.GA27252@srcf.ucam.org>
References: <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
 <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
 <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
 <4CE1968D.3050706@xs4all.nl>
 <4DE8DC16.6030308@xs4all.nl>
 <20110603133351.GA25130@srcf.ucam.org>
 <4DE8EF13.9030609@xs4all.nl>
 <20110603144644.GA26782@srcf.ucam.org>
 <4DECEBE6.3060302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DECEBE6.3060302@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 05:01:58PM +0200, Maarten Lankhorst wrote:
> Maybe this is causing the pager issue on 3.0, can you test this patch?

Looks good to me. Can you post this to x86@ ?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
