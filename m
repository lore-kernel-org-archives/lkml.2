Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1BWWXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:23:47 -0500
Received: from kroah.org ([198.145.64.141]:36027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab1BWWXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:23:46 -0500
Date: Wed, 23 Feb 2011 14:04:21 -0800
From: Greg KH <greg@kroah.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging/zcache: Add braces for else, if 'if' had some
Message-ID: <20110223220421.GA23385@kroah.com>
References: <1298081755-9114-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298081755-9114-1-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 03:15:55AM +0100, Peter Huewe wrote:
> This patch fixes a Coding Style issue by adding needed braces for the
> else branches, if the preceding 'if' branch had braces around it.
> 
> Rationale: CodingStyle.txt Section 3

That's not a good rationale, the existing code is just fine as-is,
sorry.

thanks,

greg k-h
