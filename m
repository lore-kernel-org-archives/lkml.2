Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774Ab0FRRDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:03:35 -0400
Received: from kroah.org ([198.145.64.141]:34586 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740Ab0FRRDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:03:32 -0400
Date: Fri, 18 Jun 2010 10:03:07 -0700
From: Greg KH <greg@kroah.com>
To: Mike Sheldon <mike@mikeasoft.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] Staging: winbond: Fix spacing around brackets
 and colons
Message-ID: <20100618170307.GA5620@kroah.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 12:39:38AM +0100, Mike Sheldon wrote:
> Patches mac_structures.h to correct the spacing around brackets and colons as reported by checkpatch.pl

This series doesn't apply at all, what tree did you make it against?

Can you redo it against the latest linux-next tree to make sure you got
all of the recent changes that happened in here for the 2.6.35-rc1
release and resend it?

thanks,

greg k-h
