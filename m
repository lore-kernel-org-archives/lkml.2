Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1K2TjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 14:39:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800Ab1K2TjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 14:39:16 -0500
Date: Tue, 29 Nov 2011 21:40:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: arch/mn10300/unit-asb2305/pci-iomap.c and IORESOURCE_CACHEABLE
Message-ID: <20111129194054.GA2993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_iomap on unit seems not to set non cacheable flag
(0x20000000) in the address even if IORESOURCE_CACHEABLE
is cleared for a resource.
Is this intentional? Can/should we use ioremap_nocache instead?

-- 
MST
