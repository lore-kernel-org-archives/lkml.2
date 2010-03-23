Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0CWFr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 01:47:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022Ab0CWFr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 01:47:27 -0400
Date: Mon, 22 Mar 2010 22:46:16 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] pci/dmar: Combine the BIOS DMAR table warning
 messages
Message-Id: <20100322224616.5fe25097.akpm@linux-foundation.org>
In-Reply-To: <1269126097.18314.111.camel@localhost>
References: <1269126097.18314.111.camel@localhost>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patches seem reasonable.  I reordered them thusly:

panic-allow-taint-flag-for-warnings-to-be-changed-from-taint_warn.patch
panic-add-taint-flag-taint_firmware_workaround-i.patch
pci-dmar-combine-the-bios-dmar-table-warning-messages.patch
pci-dmar-tone-down-warnings-about-invalid-bios-dmar-tables.patch

so I can merge the first two and then I can feed the PCI patches into
the PCI cabal.  Alternatively they can ack them and I'll merge them
all.  Or they can snarf all four and I'll go away.

