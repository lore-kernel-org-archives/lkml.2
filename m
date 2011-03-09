Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab1CIWFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:05:42 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:39916 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab1CIWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:05:39 -0500
Date: Thu, 10 Mar 2011 07:05:35 +0900
From: Simon Horman <horms@verge.net.au>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
        trivial@kernel.org
Subject: Re: [PATCH] Fix variable assignment in ip_vs_notrack
Message-ID: <20110309220535.GB23960@verge.net.au>
References: <alpine.LNX.2.00.1103092250510.4471@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1103092250510.4471@swampdragon.chaosbits.net>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:55:05PM +0100, Jesper Juhl wrote:
> There's no sense to 'ct = ct = ' in ip_vs_notrack(). Just assign 
> nf_ct_get()'s return value directly to the pointer variable 'ct' once.

Thanks Jesper, applied to lvs-test-2.6.
