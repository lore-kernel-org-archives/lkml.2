Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab0I2RlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:41:14 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:46619 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0I2RlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:41:13 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAM8Wo0yrR7Hu/2dsb2JhbACiGnGrW5xvhUQEhFCFaoR5
X-IronPort-AV: E=Sophos;i="4.57,254,1283731200"; 
   d="scan'208";a="262336027"
From: Roland Dreier <rdreier@cisco.com>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/cxgb4: Add default_llseek to debugfs files.
References: <20100929141112.26944.21931.stgit@build.ogc.int>
	<adawrq431sr.fsf@cisco.com> <4CA37715.4020302@opengridcomputing.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 29 Sep 2010 10:41:08 -0700
In-Reply-To: <4CA37715.4020302@opengridcomputing.com> (Steve Wise's message of
	"Wed, 29 Sep 2010 12:27:49 -0500")
Message-ID: <adask0s30sr.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I assume you mean debugs_read()...Like this?

Sorry, yeah, was looking at the old code.  But yes, that code seems a
lot simpler.
