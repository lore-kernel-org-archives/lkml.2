Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab1FWRWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:22:06 -0400
Received: from sous-sol.org ([216.99.217.87]:40273 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759837Ab1FWRWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:04 -0400
Date: Thu, 23 Jun 2011 10:20:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Avi Kivity <avi@redhat.com>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
Message-ID: <20110623172053.GV25383@sequoia.sous-sol.org>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com>
 <1308843536.16742.48.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308843536.16742.48.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Woodhouse (dwmw2@infradead.org) wrote:
> I'd much rather KVM just gave us a list of the pages to map, in a single
> call.

This makes most sense to me.
