Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0I2Rul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:50:41 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:37951 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0I2Ruj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:50:39 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJ8Zo0yrRN+K/2dsb2JhbACiGnGrb5xvhUQEhFCFaoR5
X-IronPort-AV: E=Sophos;i="4.57,255,1283731200"; 
   d="scan'208";a="193625259"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>
	<adawrq431sr.fsf@cisco.com> <4CA37715.4020302@opengridcomputing.com>
	<adask0s30sr.fsf@cisco.com> <4CA37C11.2040603@opengridcomputing.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Sep 2010 10:50:31 -0700
In-Reply-To: <4CA37C11.2040603@opengridcomputing.com> (Steve Wise's message of
	"Wed, 29 Sep 2010 12:49:05 -0500")
Message-ID: <adalj6k30d4.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'll change it, test it,  and send you a patch.

great, thanks.
