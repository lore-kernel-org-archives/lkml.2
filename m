Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0FRXtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 19:49:15 -0400
Received: from kroah.org ([198.145.64.141]:53029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab0FRXtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 19:49:14 -0400
Date: Fri, 18 Jun 2010 16:45:22 -0700
From: Greg KH <greg@kroah.com>
To: nanakos@wired-net.gr
Cc: gregkh@suse.de, horms@verge.net.au, hsweeten@visionengravers.com,
       ss@aao.gov.au, randy.dunlap@oracle.com, tj@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: dt3155: dt3155_drv.c: Fix checkpatch.pl
 issues.
Message-ID: <20100618234522.GA19602@kroah.com>
References: <1274988042-7716-1-git-send-email-nanakos@wired-net.gr>
 <1274988042-7716-2-git-send-email-nanakos@wired-net.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274988042-7716-2-git-send-email-nanakos@wired-net.gr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:20:42PM +0000, nanakos@wired-net.gr wrote:
> From: Nanakos Chrysostomos <nanakos@wired-net.gr>
> 
> Fix resolves checkpatch.pl issues for dt3155_drv.c file.

No, it breaks the build, and changes the logic a bit.  Please always at
least test-build your patches, it saves me a lot of time...

I can't apply this one, sorry.

greg k-h
