Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab0GUTqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:46:53 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:30783 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab0GUTqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:46:51 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFfrRkyrRN+J/2dsb2JhbACfdHGnKZsZhTIEhAA
From: Roland Dreier <rdreier@cisco.com>
To: Alexander Schmidt <alexs@linux.vnet.ibm.com>
Cc: Linux RDMA <linux-rdma@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Stefan Roscher <stefan.roscher@de.ibm.com>,
        Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
        Christoph Raisch <raisch@de.ibm.com>
Subject: Re: [PATCH] ib/ehca: Catch failing ioremap()
References: <20100705181925.2e34d798@alex-laptop>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 21 Jul 2010 12:46:48 -0700
In-Reply-To: <20100705181925.2e34d798@alex-laptop> (Alexander Schmidt's
	message of "Mon, 5 Jul 2010 18:19:25 +0200")
Message-ID: <adatynsmxcn.fsf@roland-alpha.cisco.com>
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
