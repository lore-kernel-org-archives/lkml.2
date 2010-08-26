Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0HZUJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 16:09:15 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:51603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752684Ab0HZUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 16:09:12 -0400
Date: Thu, 26 Aug 2010 22:09:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "akpm@kernel.org" <akpm@kernel.org>
Subject: Re: [PATCH RFC 1/1] MISC: Broadcom BCM4751 GPS driver
Message-ID: <20100826200905.GB20776@elf.ucw.cz>
References: <1282572026-14905-1-git-send-email-matti.j.aaltonen@nokia.com>
 <1282572026-14905-2-git-send-email-matti.j.aaltonen@nokia.com>
 <20100825060704.GA1578@ucw.cz>
 <1282815075.14489.249.camel@masi.mnp.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282815075.14489.249.camel@masi.mnp.nokia.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-08-26 12:31:15, Matti J. Aaltonen wrote:
> Hello.
> 
> On Wed, 2010-08-25 at 08:07 +0200, ext Pavel Machek wrote:
> > On Mon 2010-08-23 17:00:26, Matti J. Aaltonen wrote:
> > > Driver for Broadcom BCM4751 GPS chip.
> > 
> > 
> > Uhuh. Tell us more... like what's the interface to userspace? NMEA
> > data over char device?
> 
> The interface to user space is MEIF data over a char device. Something
> about MEIF can be found at
> 
> http://www.forum.nokia.com/info/sw.nokia.com/id/b265d3aa-8198-4eb0-a0e3-077748ccea40/MEIF_Specification_License.pdf.html
> 

Umm, that contains some legaleese, but nothing useful...?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
