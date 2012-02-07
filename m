Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2BGRSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 12:18:23 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52286 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2BGRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 12:18:22 -0500
Date: Tue, 7 Feb 2012 17:18:17 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.2.5
Message-ID: <20120207171817.GA31258@srcf.ucam.org>
References: <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
 <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
 <20120207165416.GA27342@citd.de>
 <20120207165944.GA30442@srcf.ucam.org>
 <20120207170709.GA28108@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207170709.GA28108@citd.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 06:07:09PM +0100, Matthias Schniedermeyer wrote:

> Works too. What is the difference (in my case)?

In your case, nothing. For other systems it means that we'd still refuse 
to enable ASPM on pre-1.1 devices.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
