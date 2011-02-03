Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1BCK1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 05:27:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:35171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756128Ab1BCK07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 05:26:59 -0500
Date: Thu, 3 Feb 2011 11:26:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tcp_ecn is an integer not a boolean
In-Reply-To: <w4vd12m4it.wl%peter@chubb.wattle.id.au>
Message-ID: <alpine.LNX.2.00.1102031126470.2160@pobox.suse.cz>
References: <w4vd12m4it.wl%peter@chubb.wattle.id.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, Peter Chubb wrote:

> 
> There was some confusion at LCA as to why the sysctl tcp_ecn took one
> of three values when it was documented as a Boolean.  This patch fixes
> the documentation.
> 
> Signed-off-by: Peter Chubb <peter.chubb@nicta.com.au>
> 
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index d99940d..ac3b4a7 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -187,7 +187,7 @@ tcp_cookie_size - INTEGER
>  tcp_dsack - BOOLEAN
>  	Allows TCP to send "duplicate" SACKs.
>  
> -tcp_ecn - BOOLEAN
> +tcp_ecn - INTEGER

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
