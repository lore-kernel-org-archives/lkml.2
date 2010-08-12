Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782Ab0HLMq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:46:26 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:53136 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab0HLMqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:46:23 -0400
Date: Thu, 12 Aug 2010 14:45:42 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: [GIT PULL] arch/cris changes for 2.6.36
Message-ID: <20100812124541.GP17485@axis.com>
References: <20100806085337.GA17485@axis.com> <20100809122628.GC17485@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809122628.GC17485@axis.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Another change for 2.6.36, please pull the below repo for a compile error fix for CRIS.
(we hadn't defined io_remap_pfn_range for our architecture)

Thanks,

/Jesper


The following changes since commit f1d23ed8218ca5afaf178a6495253dbb7fc98f57:
  Claudio Scordino (1):
        CRIS: ioctl for getting RS485 information

are available in the git repository at:

  git://www.jni.nu/cris.git io_remap_pfn_range

Jesper Nilsson (1):
      CRIS: Define io_remap_pfn_range as remap_pfn_range

 arch/cris/include/asm/pgtable.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
