Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0CYQwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:52:34 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:38636 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0CYQwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:52:31 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 15621] New: BUG: unable to handle kernel paging request - comm: pccardd
Date: Thu, 25 Mar 2010 10:51:39 -0600
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai@kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       ozgur.yuksel@oracle.com, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <bug-15621-10286@https.bugzilla.kernel.org/> <20100324071229.5c42e213.akpm@linux-foundation.org>
In-Reply-To: <20100324071229.5c42e213.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003251051.40453.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It looks like the iomem_resource tree got wrecked.  Has anyone been
> changing anything in there lately?

My pci=use_crs patches change the contents of the iomem_resource tree,
and it's possible they broke some assumptions PCMCIA was making, so
you might see if "pci=nocrs" makes any difference.  If it does, please
attach an acpidump and the entire dmesg logs with and without that option.
