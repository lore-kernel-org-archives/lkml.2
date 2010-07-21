Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033Ab0GUTrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:47:05 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:48768 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab0GUTqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:46:52 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABrrRkyrR7Hu/2dsb2JhbACfdHGnKJsZhTIEhAA
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Linux RDMA <linux-rdma@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stefan Roscher <stefan.roscher@de.ibm.com>,
        Joachim Fenkes <fenkes@de.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>,
        Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: Re: [PATCH] ib/ehca: init irq tasklet before irq can happen
References: <20100705134156.36803536@alex-laptop>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 21 Jul 2010 12:46:52 -0700
In-Reply-To: <20100705134156.36803536@alex-laptop> (Alexander Schmidt's
	message of "Mon, 5 Jul 2010 13:41:56 +0200")
Message-ID: <adapqygmxcj.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
