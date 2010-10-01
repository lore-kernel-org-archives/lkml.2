Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab0JAXcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 19:32:19 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:46601 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0JAXcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 19:32:18 -0400
Date: Fri, 01 Oct 2010 19:31:57 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, stable@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [git pull request] ACPI patches for Linux 2.6.36-rc6
In-reply-to: <201010012308.12897.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.1010011930220.6869@localhost.localdomain>
References: <alpine.LFD.2.00.1010010142470.7033@localhost.localdomain>
 <201010012308.12897.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > commit 573b638158029898caf9470c8214b7ddd29751e3
> > Author: Colin Ian King <colin.king@canonical.com>
> > Date:   Mon Aug 2 15:14:43 2010 +0000
> 
> This one should go to -stable, shouldn't it?

yes, plus and a couple of the others.

FYI, I generally push to .stable when I go to delete the topic branches
that Linus has pulled and close applicable bug reports.

thanks,
Len Brown, Intel Open Source Technology Center
