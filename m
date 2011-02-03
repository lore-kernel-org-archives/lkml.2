Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1BCJsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:48:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab1BCJsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:48:45 -0500
Date: Thu, 3 Feb 2011 07:44:34 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, Dean Nelson <dnelson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2 0/3] KVM, Replace is_hwpoison_address with
 __get_user_pages
Message-ID: <20110203094434.GA2069@amt.cnet>
References: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296357349-18022-1-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 30, 2011 at 11:15:46AM +0800, Huang Ying wrote:
> v2:
> 
> - Export __get_user_pages, because we need other get_user_pages variants too.
> 
> 
> [PATCH -v2 1/3] mm, export __get_user_pages
> [PATCH -v2 2/3] mm, Make __get_user_pages return -EHWPOISON for HWPOISON page optionally
> [PATCH -v2 3/3] KVM, Replace is_hwpoison_address with __get_user_pages
> --

Applied, thanks.

