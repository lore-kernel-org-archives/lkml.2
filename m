Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1JDGbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 02:31:49 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:38953 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab1JDGbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 02:31:48 -0400
Date: Tue, 4 Oct 2011 07:31:47 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: kmemleak and SLAB
Message-ID: <20111004063147.GA12229@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When I try to use kmemleak with the SLAB allocator set I receive this
message when booting 3.1-rc8:

[   28.480569] kmemleak: Cannot allocate a kmemleak_object structure
[   28.480593] kmemleak: Kernel memory leak detector disabled
[   34.428037] CPA self-test:
[   34.435881]  4k 259968 large 0 gb 0 x 259968[b0000000-ef77f000] miss 0
[   34.447669]  4k 259968 large 0 gb 0 x 259968[b0000000-ef77f000] miss 0
[   34.458402]  4k 259968 large 0 gb 0 x 259968[b0000000-ef77f000] miss 0
[   34.458407] ok.
[   38.754032] wlan0: no IPv6 routers present
[   67.666048] kmemleak: Automatic memory scanning thread ended

All is fine when using SLUB. On another run I also got an error about an
ODEBUG oom so I wonder if this is indicative of another problem...

-- 
Sitsofe | http://sucs.org/~sits/
