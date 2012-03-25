Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab2CYJff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 05:35:35 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56077 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2CYJfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 05:35:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 25 Mar 2012 11:35:25 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: lib/crc32: new Kconfig prompt without help text
Message-ID: <20120325113525.778eb2cd@stein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

the new prompt "CRC32 implementation" doesn't have an own help text, only
its subsequent options have.  This is fine with a configurator like
xconfig.  But "make oldconfig" only shows help text at the choice itself,
not at the options:

$ make oldconfig
[...]
> CRC32/CRC32c functions (CRC32) [Y/?] y
>   CRC32 perform self test on init (CRC32_SELFTEST) [N/y/?] (NEW) 
>   CRC32 implementation
>   > 1. Slice by 8 bytes (CRC32_SLICEBY8) (NEW)
>     2. Slice by 4 bytes (CRC32_SLICEBY4) (NEW)
>     3. Sarwate's Algorithm (one byte at a time) (CRC32_SARWATE) (NEW)
>     4. Classic Algorithm (one bit at a time) (CRC32_BIT) (NEW)
>   choice[1-4]: ?
> 
> There is no help available for this option.

-- 
Stefan Richter
-=====-===-- --== ==--=
http://arcgraph.de/sr/
