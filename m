Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1C0XZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 19:25:49 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:31578 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab1C0XZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 19:25:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjUEAMzEj015LK5JgWdsb2JhbACEQ6ENFQEBFiYlsGePOQ2BGoNLdwSSdQ
Date: Mon, 28 Mar 2011 10:25:43 +1100
From: Dave Chinner <david@fromorbit.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: 2.6.38.1: CPU#0 stuck for 67s! / xfs_ail_splice
Message-ID: <20110327232543.GU26611@dastard>
References: <alpine.DEB.2.02.1103260927500.21571@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.02.1103260927500.21571@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 09:29:36AM -0400, Justin Piszcz wrote:
> Hi,
> 
> When I rm -rf a directory of a few hundred thousand
> files/directories on XFS under 2.6.38.1, I see the following, is
> this normal?

No. What is you filesystem config (xfs_info) and your mount options?
Is it repeatable? Iѕ the system otherwise stalled or is it still
operating normally? Does it recover and work normally after such a
stall?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
