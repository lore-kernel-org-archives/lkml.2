Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab2D0BBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 21:01:44 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:36269 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab2D0BBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 21:01:43 -0400
Date: Fri, 27 Apr 2012 10:01:40 +0900
From: Simon Horman <horms@verge.net.au>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH] IPVS: ip_vs_ftp.c: local functions should not be exposed
 globally
Message-ID: <20120427010140.GD5105@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204261126.15699.hartleys@visionengravers.com>
 <201204261117.28491.hartleys@visionengravers.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 11:17:28AM -0700, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent it from being exposed globally.
> 
> This quiets the sparse warnings:
> 
> warning: symbol 'ip_vs_ftp_init' was not declared. Should it be static?

On Thu, Apr 26, 2012 at 11:26:15AM -0700, H Hartley Sweeten wrote:
> Functions not referenced outside of a source file should be marked
> static to prevent it from being exposed globally.
> 
> This quiets the sparse warnings:
> 
> warning: symbol '__ipvs_proto_data_get' was not declared. Should it be static?
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Thanks, I have applied these to ipvs-next.

git://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs-next.git
