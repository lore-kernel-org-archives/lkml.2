Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0GAIGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 04:06:08 -0400
Received: from ns2.tasking.nl ([195.193.207.10]:20240 "EHLO ns2.tasking.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0GAIGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 04:06:06 -0400
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 04:06:06 EDT
From: Kees Bakker <kees.bakker@xs4all.nl>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: Filename case conflict Documentation/io-mapping.txt and Documentation/IO-mapping.txt
Date: Thu, 1 Jul 2010 09:58:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
References: <97A9C0E5-DA16-4C78-89A3-BBC08EF16518@xs4all.nl> <20100630151806.08a1823c.rdunlap@xenotime.net>
In-Reply-To: <20100630151806.08a1823c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007010958.15986.kees.bakker@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 July 2010, Randy Dunlap wrote:
> On Wed, 30 Jun 2010 22:58:21 +0200 Kees Bakker wrote:
> 
> > Hi,
> > 
> > Do we really want these two filenames as they are right now?
> > We have:
> >    Documentation/IO-mapping.txt
> >    Documentation/io-mapping.txt
> > 
[...]
> > 
> > So the IO-mapping.txt was there first. Keith, can't we rename your
> > file? For example,
> > 
> >    Documentation/io-mapping.txt => Documentation/io-mapping.h.txt
> > -- 
> 
> Alternatively:
> 
> $ git mv Documentation/IO-mapping.txt Documentation/bus-virt-phys-mapping.txt

Sounds good to me.
-- 
Kees
