Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0CYRTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:19:55 -0400
Received: from isilmar.linta.de ([213.133.102.198]:41851 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752036Ab0CYRTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:19:53 -0400
Date: Thu, 25 Mar 2010 18:01:38 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yinghai@kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>, bugzilla-daemon@bugzilla.kernel.org,
       bugme-daemon@bugzilla.kernel.org, ozgur.yuksel@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel
 paging request - comm: pccardd
Message-ID: <20100325170138.GA5424@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, ozgur.yuksel@oracle.com,
	linux-kernel@vger.kernel.org
References: <bug-15621-10286@https.bugzilla.kernel.org/>
 <20100324071229.5c42e213.akpm@linux-foundation.org>
 <201003251051.40453.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003251051.40453.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Mar 25, 2010 at 10:51:39AM -0600, Bjorn Helgaas wrote:
> > It looks like the iomem_resource tree got wrecked.  Has anyone been
> > changing anything in there lately?
> 
> My pci=use_crs patches change the contents of the iomem_resource tree,
> and it's possible they broke some assumptions PCMCIA was making, so
> you might see if "pci=nocrs" makes any difference.  If it does, please
> attach an acpidump and the entire dmesg logs with and without that option.

... and /proc/iomem as well as /proc/ioports , please.
