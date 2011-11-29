Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab1K2Swn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:52:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab1K2Swl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:52:41 -0500
Date: Tue, 29 Nov 2011 20:54:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Mundt <lethal@linux-sh.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH-RFC 0/2] tile: switch to generic pci_iomap
Message-ID: <cover.1322592494.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a completely untested patch to switch tile
over to the new pci_iomap (in -mm).

This is on top of pci: use generic pci_iomap in most architectures,
and converts just the tile architecture.

Seems straightforward enough but completely untested - could someone
with access to appropriate systems respond and say whether
the first patch in the series is OK?
The second one should then be trivial.

-- 
1.7.5.53.gc233e
