Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722Ab0DHU4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:56:25 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:32590 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab0DHU4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:56:21 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAfgvUurR7H+/2dsb2JhbACbOXGibJk3hQkEgyQ
X-IronPort-AV: E=Sophos;i="4.52,172,1270425600"; 
   d="scan'208";a="112554524"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 4/6] pci/dmar/sriov: use physfn to search drhd for VF
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
	<1270753107-15881-5-git-send-email-yinghai@kernel.org>
	<adawrwhwyiq.fsf@roland-alpha.cisco.com> <4BBE4209.3080900@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 08 Apr 2010 13:56:17 -0700
In-Reply-To: <4BBE4209.3080900@oracle.com> (Yinghai's message of "Thu, 08 Apr
	2010 13:52:25 -0700")
Message-ID: <adaaatdwtn2.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.
-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
