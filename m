Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab0I2Tka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 15:40:30 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:33613 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab0I2Tk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 15:40:28 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALMyo0yrRN+J/2dsb2JhbACiHHGrRJxphUQEhFCFaoR5
X-IronPort-AV: E=Sophos;i="4.57,255,1283731200"; 
   d="scan'208";a="281939047"
From: Roland Dreier <rdreier@cisco.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>
	<201009292117.54828.arnd@arndb.de> <ada4od82w5x.fsf@cisco.com>
	<201009292129.31415.arnd@arndb.de>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Sep 2010 12:40:19 -0700
In-Reply-To: <201009292129.31415.arnd@arndb.de> (Arnd Bergmann's message of
	"Wed, 29 Sep 2010 21:29:31 +0200")
Message-ID: <adazkv01gpo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yes, but it's a very weak "should". My automatic conversion script
 > uses default_llseek.

OK, I'll just take steve's patch that does default_llseek if it really
doesn't matter.

 - R.
