Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091Ab0JZQst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 12:48:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:41977 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759628Ab0JZQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 12:48:48 -0400
Subject: RE: linux-next: build warnings after merge of the final tree (mtd
 tree related)
From: David Woodhouse <dwmw2@infradead.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <0D753D10438DA54287A00B027084269764818E2136@AUSP01VMBX24.collaborationhost.net>
References: <20101026134959.86b807d1.sfr@canb.auug.org.au>
	 <1288083108.29264.14.camel@macbook.infradead.org>
	 <1288090180.29264.26.camel@macbook.infradead.org>
	 <0D753D10438DA54287A00B027084269764818E2136@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 17:48:34 +0100
Message-ID: <1288111714.8551.0.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.0 (2.32.0-2.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 11:43 -0500, H Hartley Sweeten wrote:
> I didn't follow the logic for the MTD_MAP_BANK_WIDTH_* all the way thru.
> 
> Honestly I still don't quite get it.  If MTD_CFI_GEOMETRY is n wouldn't
> all the MTD_MAP_BANK_WIDTH_* also be n? 

config MTD_CFI_GEOMETRY
        bool "Specific CFI Flash geometry selection"
        depends on MTD_CFI_ADV_OPTIONS
        help
          This option does not affect the code directly, but will enable
          some other configuration options which would allow you to reduce
          the size of the kernel by including support for only certain
          arrangements of CFI chips. If unsure, say 'N' and all options
          which are supported by the current code will be enabled.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

