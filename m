Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab0KAUbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:31:38 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:46942 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab0KAUbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:31:37 -0400
X-Greylist: delayed 1373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Nov 2010 16:31:37 EDT
Date: Mon, 1 Nov 2010 16:08:22 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Initialize source address if passed-in srcaddr
 is AF_UNSPEC
Message-ID: <20101101200822.GA3598@elliptictech.com>
Mail-Followup-To: Chuck Lever <chuck.lever@oracle.com>,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20101101195631.9279.16018.stgit@matisse.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101195631.9279.16018.stgit@matisse.1015granger.net>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-01 15:58 -0400, Chuck Lever wrote:
> Recently xs_bind() was changed so it can't tolerate an AF_UNSPEC
> bind address; it needs a fully initialized ANYADDR.  We recently fixed
> this case in xprtsock.c, but some upper layer protocols seem to assume
> that it's OK to pass in an AF_UNSPEC address for the source address.
> Catch that case too.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
> 
> Untested.

This one seems to correct the issue.

Tested-by: Nick Bowler <nbowler@elliptictech.com>

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
