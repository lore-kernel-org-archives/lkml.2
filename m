Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab0DHTdt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 15:33:49 -0400
Received: from sous-sol.org ([216.99.217.87]:60580 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933458Ab0DHTcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 15:32:54 -0400
Date: Thu, 8 Apr 2010 12:31:01 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wright <chrisw@sous-sol.org>, David.Woodhouse@intel.com,
       fenghua.yu@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 5/6] pci/dmar: Fix link warning
Message-ID: <20100408193101.GE3168@sequoia.sous-sol.org>
References: <1270753107-15881-1-git-send-email-yinghai@kernel.org>
 <1270753107-15881-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270753107-15881-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu (yinghai@kernel.org) wrote:
> could make it to be __init to remove the linking section mismatch warning.

Hey David, I just noticed this one is already in your tree, looks like
the only commit in there that didn't get pushed, accidentally stuck
perhaps?

thanks,
-chris
