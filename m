Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab1BGLkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:40:16 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61483 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab1BGLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:40:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g0KYLVkuNOpX/olmkIrLLB0m/chlRJt4RdV9Z6r+yOMA0QHMEiL60TAoNUCBki7gha
         Ya2ehlmSEYAdkJlfxGAJZ+a60d0QNGogcg8dxoIvp42ODDCD8IUJr3G+pW4cqHa3lijp
         qZh3WBVgmiPeJ+VChIpKqumQvk4rHIllas4oE=
Date: Mon, 7 Feb 2011 13:40:05 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Documentation: log_buf_len accepts [KMG]
Message-ID: <20110207114005.GB10388@laptop>
References: <20110206174504.GA23024@laptop> <20110206204002.2f3eab4e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206204002.2f3eab4e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 08:40:02PM -0800, Randy Dunlap wrote:
> 
> Update the "log_buf_len" description to use [KMG] syntax for the
> buffer size.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> 

This implies an ACK for the original patch?

-- 
Darwish
http://darwish.07.googlepages.com
