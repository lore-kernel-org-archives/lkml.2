Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121Ab2CHQYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:24:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab2CHQYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:24:44 -0500
Date: Thu, 8 Mar 2012 16:24:41 +0000
From: Mel Gorman <mgorman@suse.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: decode GFP flags in oom killer output.
Message-ID: <20120308162441.GG17697@suse.de>
References: <20120307233939.GB5574@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120307233939.GB5574@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 06:39:39PM -0500, Dave Jones wrote:
> Decoding these flags by hand in oom reports is tedious,
> and error-prone.
> 

It's not really a proper solution but scripts/gfp-translate is less
error-prone than doing it by hand but requires that you have the kernel
source available.

-- 
Mel Gorman
SUSE Labs
