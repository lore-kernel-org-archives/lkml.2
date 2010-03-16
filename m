Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab0CPT73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 15:59:29 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:26020 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab0CPT7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 15:59:25 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH v1 0/3] [RFC] resource, PCI: work around pci=use_crs conflicts
Date: Tue, 16 Mar 2010 12:59:14 -0700
User-Agent: KMail/1.9.10
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yanko Kaneti <yaneti@declera.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, maciej.rutecki@gmail.com
References: <20100311235954.4355.23100.stgit@bob.kio>
In-Reply-To: <20100311235954.4355.23100.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003161359.15419.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010 05:01:03 pm Bjorn Helgaas wrote:
> These patches are to fix this pci=use_crs regression:
> 
>     http://bugzilla.kernel.org/show_bug.cgi?id=15480
> 
> The problem is that BIOS reported a PCI host bridge window that overlaps
> system RAM.  This workaround trims the window to avoid the overlap, which
> requires information about the conflicting resource.

Any opinions on these?  Yanko tested them and verified that they
fix the regression above.

Patch [3/3] only improves some debug, so that can wait until next
time around.

Bjorn
