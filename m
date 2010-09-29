Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0I2ISG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:18:06 -0400
Received: from mail.southpole.se ([193.12.106.18]:53021 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab0I2ISE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:18:04 -0400
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Sep 2010 04:18:04 EDT
Subject: ioremap definition in generic io.h
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: South Pole AB
Date: Wed, 29 Sep 2010 09:59:05 +0200
Message-ID: <1285747145.12259.3.camel@needafix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm wondering about the usefulness of the definition of ioremap and
__ioremap in asm-generic/io.h.  How is this intended to be used?  How
are the page tables for this mapping supposed to be constructed?

The definition is as follows:

/*
 * Change "struct page" to physical address.
 */
static inline void __iomem *ioremap(phys_addr_t offset, unsigned long
size)
{
        return (void __iomem*) (unsigned long)offset;
}

#define __ioremap(offset, size, flags)  ioremap(offset, size)

Regards,
Jonas




