Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab1CaFbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 01:31:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47259 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab1CaFbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 01:31:14 -0400
Date: Thu, 31 Mar 2011 07:31:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, stefano.stabellini@eu.citrix.com,
        ak@linux.intel.com, hpa@zytor.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [225/275] x86: Cleanup highmap after brk is concluded
Message-ID: <20110331053109.GK21838@one.firstfloor.org>
References: <20110330203.501921634@firstfloor.org> <20110330210750.9B0D63E1A05@tassilo.jf.intel.com> <4D941084.5040700@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D941084.5040700@kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:26:28PM -0700, Yinghai Lu wrote:
> gentoo guys reported this one cause resume freeze.
> 
> https://bugs.gentoo.org/show_bug.cgi?id=361159

thanks. dropped.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
